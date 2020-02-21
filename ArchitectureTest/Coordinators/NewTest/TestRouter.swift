//
//  TestRouter.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 21.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class TestRouter<T: CoordinatorState>: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    
    private var navigationController: UINavigationController
    var stateMachine: StatesMachine<T>
    
    init(navigationController: UINavigationController, stateMachine: StatesMachine<T>) {
        self.navigationController = navigationController
        self.stateMachine = stateMachine
        
        super.init()
        self.navigationController.delegate = self
    }
    
    func open(_ controller: UIViewController, for state: T, with transition: Transition) {
        if let presentedController = navigationController.presentedViewController {
            print("cant do nothing")
            return
        }
        
        stateMachine.push(StateHolder(state: state, controller: controller, transition: transition))
        
        if let modalTransition = transition as? ModalTransition {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = modalTransition.presentationStyle
            controller.modalTransitionStyle = modalTransition.transitionStyle
            navigationController.present(controller, animated: transition.animated)
        } else {
            navigationController.pushViewController(controller, animated: transition.animated)
        }
    }
    
    private func back(state: StateHolder<T>) {
        guard let currentState = stateMachine.currentState else  { return }
        
        if let modalTransition = currentState.transition as? ModalTransition {
            // maybe need additional navigation on pushController
            currentState.controller.dismiss(animated: modalTransition.animated, completion: nil)
        } else {
            navigationController.popToViewController(state.controller, animated: currentState.transition.animated)
        }
    }
    
    func goBack(to viewController: UIViewController) {
        guard let toState = stateMachine.lastElement(viewController) else {
            print("There is not such viewController (\(viewController)) inside StateMachine ")
            return
        }
            
        back(state: toState)
    }
    
    func goBack(to state: T) {
        guard let toState = stateMachine.lastElement(state) else {
            print("There is not such state (\(state)) inside StateMachine")
            return
        }
        
        back(state: toState)
    }
    
    func goBack() {
        guard let toState = stateMachine.previousState else {
            print("Can't go back, there is not previous state")
            return
        }
        
        back(state: toState)
    }
    
    private func movedBack(to controller: UIViewController) {
        stateMachine.popTo(controller)
    }

 // MARK: -  UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        self.movedBack(to: module.controller)
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let controller = operation == .push ? toVC : fromVC
        
        guard let module = stateMachine.lastElement(controller) else {
            print("Controller not to pop found")
            return nil
        }
        
        guard let animator = module.transition.animator  else {
            if operation == .pop {
                self.movedBack(to: toVC)
            }
            return nil
        }
        
        
        
        if operation == .push {
            animator.isPresenting = true
            return animator
        }
        else {
            self.movedBack(to: toVC)
            animator.isPresenting = false
            return animator
        }
    }
    
    
    // MARK: -  UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let controller = stateMachine.lastElement(presented) else {
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
        guard let controller = stateMachine.lastElement(dismissed) else {
            print("Controller to dismiss not found")
            return nil
        }
        
        guard let animator = controller.transition.animator  else {
            stateMachine.pop()
            return nil
        }
        
        stateMachine.pop()
        animator.isPresenting = false
        return animator
    }
    
}

