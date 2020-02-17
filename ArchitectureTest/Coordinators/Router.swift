//
//  Router.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 14.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class PresentableModule: UIViewController {
    
    weak var transition: BaseTransition?
    var myTransition: MyTransition?
    
}

struct MyTransition {
    enum TransitionType {
        case push
        case modal
    }
    
    var animator: Animator?
    var isAnimated: Bool = true
    var type: TransitionType = .push
}

class Router: NSObject {
    
    
    
    let navigationController: UINavigationController
    public var modules = [PresentableModule]()
    public var controllers: [UIViewController] {
        return navigationController.viewControllers
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        navigationController.delegate = self
    }
    
    func presentViewController(_ controller: UIViewController, transition: BaseTransition) {
        navigationController.pushViewController(controller, animated: transition.animated)
    }
    
    func pop(to viewController: UIViewController, animated: Bool = true) {
        navigationController.popToViewController(viewController, animated: animated)
    }
    
    //should use module here PreentableModule
    func open(viewController: PresentableModule, transition: MyTransition) {
        viewController.myTransition = transition
        modules.append(viewController)
        switch transition.type {
        case .modal:
            viewController.transitioningDelegate = self
            navigationController.present(viewController, animated: transition.isAnimated)
        case .push:
            navigationController.pushViewController(viewController, animated: transition.isAnimated)
        }
    }
    
    func close(viewController: PresentableModule) {
        guard let index = indexOfModule(module: viewController) else {
            print("failed index")
            return
        }
        
        modules.remove(at: index)
    }
    
    private func indexOfModule(module: PresentableModule) -> Int? {
       return modules.firstIndex(where: {$0 == module})
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
        
        guard let animator = controller.myTransition?.animator  else {
            return nil
        }
        
        if operation == .push {
            animator.isPresenting = true
            return animator
        }
        else {
            animator.isPresenting = false
            self.close(viewController: controller)
            return animator
        }
    }
}

extension Router: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       guard let controller = modules.filter({ $0 == presenting }).first else {
            print("Controller not found")
            return nil
        }
        
        guard let animator = controller.myTransition?.animator  else {
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
        
        guard let animator = controller.myTransition?.animator  else {
            return nil
        }
        
        self.close(viewController: controller)
        animator.isPresenting = false
        return animator
    }
}
