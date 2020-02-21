//
//  FeedCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 21.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class FeedCoordinator: Coordinator {
    
    class ModuleFactory: InitialViewControllerFactoryType & FinishViewControllerFactoryType & AuthViewControllerFactoryType & ProfileViewControllerFactoryType & SignUpViewControllerFactoryType & ForgotPasswordViewControllerFactoryType {}
    
    class CoordinatorFactory: ChatCoordinatorFactory {}

    enum State: CoordinatorState {
        case initial
        case finish
        case test1
        case test2
        case auth
        case register
        case forgotPassword
        case profile
        case main
        
        var transition: Transition {
            switch self {
            case .finish:
                                return ModalTransition(presentationStyle: .overFullScreen)
//                return ModalTransition(animator: FadeAnimator())
            case .auth, .forgotPassword:
                return PushTransition()
            case .main, .profile:
                return ModalTransition()
            case .register:
                //                return ModalTransition(animated: true, animator: FadeAnimator())
                //                return ModalTransition()
                return PushTransition()
            case .initial:
                return PushTransition()
            default:
//                            return PushTransition()
                return PushTransition(animated: true, animator: FadeAnimator())
            }
            
        }
    }
    
    struct Storage {
        var phoneNumber: String = ""
    }
    
    
    private var navigationController: UINavigationController
    private var childCoordinators = [Coordinator]()
    private var currentState = State.auth
    private var moduleFactory: ModuleFactory = ModuleFactory()
    private var coordinatorFactory: CoordinatorFactory = CoordinatorFactory()
    private var storage = Storage()
    private var stateMachine = StatesMachine<State>()
    private var router: TestRouter<State>
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.router = TestRouter(navigationController: self.navigationController, stateMachine: self.stateMachine)
    }

    func start() {
        moveForward(to: currentState)
    }

    private func moveForward(to state: State) {
        currentState = state
        
        if let controller = makeController() {
            router.open(controller, for: state, with: state.transition)
        } else if let coordinator = makeCoordinator() {
            childCoordinators.append(coordinator)
            coordinator.start()
        } else {
            assertionFailure("cant create module to show for state (\(state))")
        }
    }
    
    private func goBack(to state: State) {
        router.goBack(to: state)
    }
    
    private func goBack() {
        router.goBack()
    }
    
    func makeCoordinator() -> Coordinator? {
        switch currentState {
        case .main:
            return coordinatorFactory.makeChatCoordinator(navigation: self.navigationController)
        default:
            return nil
        }
    }
    
    func makeController() -> UIViewController? {
        var controller = UIViewController()
        switch currentState {
        case .initial:
            controller = moduleFactory.makeInitialController(delegate: self)
        case .finish:
            controller = moduleFactory.makeFinishController(delegate: self)
        case .test2, .test1:
            controller = BaseViewController()
        case .auth:
            return moduleFactory.makeAuthController { (state) in
                
                switch state {
                    
                case .login:
                    self.moveForward(to: .main)
                case .signup:
                    self.moveForward(to: .register)
                case .forgotPassword:
                    self.moveForward(to: .forgotPassword)
                case .success:
                    self.moveForward(to: .profile)
                }
            }
        case .register:
            return moduleFactory.makeSignUpController { (state) in
                switch state {
                    
                case .profile:
                    self.moveForward(to: .profile)
                case .login:
                    self.goBack(to: .auth)
                case .forgotPassword:
                    self.moveForward(to: .forgotPassword)
                }
            }
        case .forgotPassword:
            return moduleFactory.makeForgotPasswordController { (state) in
                switch state {
                    
                case .success:
                    self.goBack(to: .auth)
                }
            }
        case .profile:
            return moduleFactory.makeProfileController { (state) in
                switch state {
                    
                case .success:
                    self.goBack(to: .register)
                case .picture:
                    self.moveForward(to: .initial)
                }
            }
        case .main:
            return nil
            
        }

        return controller
    }
}

extension FeedCoordinator: InitialViewControllerDelegate {
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

extension FeedCoordinator: FinishViewControllerDelegate {
    func onComplete(_ controller: FinishViewController, state: FinishViewController.FinishState) {
        switch state {

        case .success:
            break
        case .cancel:
            self.goBack()
        case .back:
            self.goBack(to: .initial)
        }
    }
}
