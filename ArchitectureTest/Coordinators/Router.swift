//
//  Router.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 14.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol RouterDelegate: class {
    func removedTopModule(_ controller: UIViewController)
}

class Router: NSObject {

    let navigationController: UINavigationController
    
    struct ModuleHolder {
        let controller: UIViewController
        let transition: Transition
        
    }
    public var modules = [ModuleHolder]()

    weak var delegate: RouterDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        super.init()
        navigationController.delegate = self
    }

    //should use module here PreentableModule
    func open(viewController: UIViewController, transition: Transition) {
       
        let holder = ModuleHolder(controller: viewController, transition: transition)
        modules.append(holder)

        if let modalTransition = transition as? ModalTransition {
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = modalTransition.presentationStyle
            viewController.modalTransitionStyle = modalTransition.transitionStyle
            navigationController.present(viewController, animated: transition.animated)
        } else {
            navigationController.pushViewController(viewController, animated: transition.animated)
        }
    }

    func closeLast() {
        guard let module = modules.last else { return }

        let transition = module.transition
        
        switch transition {
        case is ModalTransition:
            module.controller.dismiss(animated: transition.animated, completion: nil)
        default:
            self.navigationController.popViewController(animated: transition.animated)
        }

        self.removeModule(module)
    }

    func back(to controller: UIViewController) -> Int {
        guard let module = modules.filter({$0.controller === controller}).last else { return 0 }
        
        let transition = module.transition

        if transition is PushTransition {
            if let controllers = navigationController.popToViewController(module.controller, animated: transition.animated) {
               self.modules.removeLast(controllers.count)
               return controllers.count
            }
        }

        return 0
    }

    private func removeModule(_ module: ModuleHolder) {
        guard let index = modules.lastIndex(where: {$0.controller === module.controller}) else {
            print("Controller to remove not found")
            return
        }

        self.modules.remove(at: index)
    }
    
    private func removeModules(to controller: UIViewController) {
        guard let index = modules.lastIndex(where: {$0.controller === controller}) else {
            print("Controller to remove not found")
            return
        }
        
        
        modules.removeLast(modules.count - index - 1)
        delegate?.removedTopModule(module.controller)
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let controller = operation == .push ? toVC : fromVC
        
        guard let module = modules.filter({ $0.controller === controller }).first else {
            print("Controller not to pop found")
            return nil
        }
        
        guard let animator = module.transition.animator  else {
            if operation == .pop {
                self.removeModule(module)
            }
            return nil
        }
        
        
        
        if operation == .push {
            animator.isPresenting = true
            return animator
        }
        else {
            self.removeModule(module)
            animator.isPresenting = false
            return animator
        }
    }
}

extension Router: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let controller = modules.filter({ $0.controller === presented }).first else {
            print("Controller to present not found")
            return nil
        }
        
        guard let animator = controller.transition.animator  else {
            return nil
        }
        
        animator.isPresenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let controller = modules.filter({ $0.controller === dismissed }).first else {
            print("Controller to dismiss not found")
            return nil
        }
        
        guard let animator = controller.transition.animator  else {
            self.removeModule(controller)
            return nil
        }
        
        self.removeModule(controller)
        animator.isPresenting = false
        return animator
    }
}
