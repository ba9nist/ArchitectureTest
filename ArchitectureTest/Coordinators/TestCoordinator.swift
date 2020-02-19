//
//  ModalCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 18.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class TestCoordinator: NSObject, Coordinator {
    class ModuleFactory: InitialViewControllerFactoryType & FinishViewControllerFactoryType {}

    enum State {
        case initial
        case finish
        case test1
        case test2

        var transition: Transition {
            switch self {
            case .finish:
                return ModalTransition(presentationStyle: .overFullScreen)
//                return ModalTransition(animator: FadeAnimator())
            default:
                //            return PushTransition()
                return PushTransition(animated: true, animator: FadeAnimator())
            }

        }
    }

    struct Storage {
        var phoneNumber: String = ""
    }

    struct StateMachine {
        var state: State
        var controller: UIViewController
    }

    weak var completionDelegate: ModalCoordinatorDeleate?

    private var navigationController: UINavigationController
    private var childCoordinators = [Coordinator]()
    private var currentState = State.initial
    private var moduleFactory: ModuleFactory = ModuleFactory()
    private var storage = Storage()
    private var stateMachine =  [StateMachine]()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()

        self.navigationController.delegate = self
    }

    func start() {
        moveForward(to: currentState)
    }

    private func moveForward(to state: State) {
        currentState = state

        if let controller = stateMachine.filter({$0.state == state}).first?.controller {
            //removing
            close(to: controller)
        } else {
            //presenting
            let controller = makeController()
            stateMachine.append(StateMachine(state: currentState, controller: controller))
            open(controller, transition: state.transition)
        }

        print(stateMachine)
    }

    private func open(_ controller: UIViewController, transition: Transition) {
        if let modal = transition as? ModalTransition {
            controller.modalPresentationStyle = modal.presentationStyle
            controller.modalTransitionStyle = modal.transitionStyle
            controller.transitioningDelegate = self
            self.navigationController.present(controller, animated: modal.animated, completion: nil)
        } else {
            //push
            self.navigationController.pushViewController(controller, animated: transition.animated)
        }
    }

    private func close(to viewController: UIViewController) {

        guard let currentState = stateMachine.filter({$0.controller === viewController}).last else { return }
        let isAnimated = currentState.state.transition.animated

        if let presentedController = navigationController.presentedViewController {
            presentedController.dismiss(animated: isAnimated) {
                self.stateMachine.removeLast()
            }
        } else {
            if let controllers = navigationController.popToViewController(viewController, animated: isAnimated) {

            }
        }
    }

    private func cleanStateMachine(to viewController: UIViewController) {
        if let index = stateMachine.lastIndex(where: {$0.controller === viewController}) {

            let removingCount = stateMachine.count - index
            stateMachine.removeLast(removingCount)

        }
    }

    func makeController() -> UIViewController {
        var controller = UIViewController()
        switch currentState {
        case .initial:
            controller = moduleFactory.makeInitialController(delegate: self)
        case .finish:
            controller = moduleFactory.makeFinishController(delegate: self)
        case .test2, .test1:
            controller = BaseViewController()
        }

        return controller
    }


}

extension TestCoordinator: InitialViewControllerDelegate {
    func onComplete(_ controller: InitialViewController, state: InitialViewController.FinishState) {
        switch state {

        case .test1:
            moveForward(to: .test1)
        case .test2:
            moveForward(to: .test2)
        case .toFinish:
            moveForward(to: .finish)
        }
    }


}

extension TestCoordinator: FinishViewControllerDelegate {
    func onComplete(_ controller: FinishViewController, state: FinishViewController.FinishState) {
        switch state {

        case .success:
            break
        case .cancel:
            break
        case .back:
            self.moveForward(to: .initial)
        }
    }


}

extension TestCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let controller = operation == .push ? toVC : fromVC

        guard let state = stateMachine.filter({ $0.controller === controller}).last else {
            print("Controller not to pop found")
            return nil
        }

        guard let animator = state.state.transition.animator  else {
            if operation == .pop {
                cleanStateMachine(to: controller)
            }
            return nil
        }

        if operation == .push {
            animator.isPresenting = true
            return animator
        }
        else {
            self.cleanStateMachine(to: controller)
            animator.isPresenting = false
            return animator
        }
    }
}

extension TestCoordinator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let controller = stateMachine.filter({ $0.controller === presented }).first else {
            print("Controller to present not found")
            return nil
        }

        guard let animator = controller.state.transition.animator  else {
            return nil
        }

        animator.isPresenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let controller = stateMachine.filter({ $0.controller === dismissed }).first else {
            print("Controller to dismiss not found")
            return nil
        }

        guard let animator = controller.state.transition.animator  else {
            return nil
        }

        animator.isPresenting = false
        return animator
    }
}

