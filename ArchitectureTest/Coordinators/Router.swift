//
//  Router.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 14.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class PresentableModule: UIViewController {
    
    var transition: Transition?
    
}

class Router: NSObject {

    let navigationController: UINavigationController
    public var modules = [PresentableModule]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        navigationController.delegate = self
    }
    
    //should use module here PreentableModule
    func open(viewController: PresentableModule, transition: Transition) {
        viewController.transition = transition
        modules.append(viewController)
        
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
        guard let module = modules.last, let transition = module.transition else { return }
        
        switch transition {
        case is ModalTransition:
            module.dismiss(animated: transition.animated, completion: nil)
        default:
            self.navigationController.popViewController(animated: transition.animated)
        }
        
        self.removeModule(module)
    }
    
    func back(to module: PresentableModule) {
        guard let transition = module.transition else {
            return
        }
        
        if transition is PushTransition {
            navigationController.popToViewController(module, animated: transition.animated)
        }
        
        if let indexOfModule = self.modules.lastIndex(where: {$0 == module}) {
            self.modules.removeLast(self.modules.count - indexOfModule - 1)
        }
    }
    
    private func removeModule(_ controller: UIViewController) {
        guard let index = modules.lastIndex(where: {$0 == controller}) else {
            print("Controller not found")
            return
        }
        
        self.modules.remove(at: index)
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let lookupVC = operation == .push ? toVC : fromVC
        
        guard let controller = modules.filter({ $0 == lookupVC }).first else {
            print("Controller not found")
            return nil
        }
        
        guard let animator = controller.transition?.animator  else {
            return nil
        }
        
        if operation == .push {
            animator.isPresenting = true
            return animator
        }
        else {
            animator.isPresenting = false
            return animator
        }
    }
}

extension Router: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       guard let controller = modules.filter({ $0 == presented }).first else {
            print("Controller not found")
            return nil
        }
        
        guard let animator = controller.transition?.animator  else {
            return nil
        }
        
        animator.isPresenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let controller = modules.filter({ $0 == dismissed }).first else {
            print("Controller not found")
            return nil
        }
        
        guard let animator = controller.transition?.animator  else {
            return nil
        }
        
        animator.isPresenting = false
        return animator
    }
}
