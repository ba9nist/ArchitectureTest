//
//  AuthorizationCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 12.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class AuthorizationCoordinator: Coordinator {
    class ModuleFactory: AuthViewControllerFactoryType & ProfileViewControllerFactoryType & SignUpViewControllerFactoryType & ForgotPasswordViewControllerFactoryType {}
    
    enum State {
        case auth
        case register
        case forgotPassword
        case profile
        case main
        
        var transition: Transition {
            switch self {
            case .auth, .forgotPassword, .profile:
                return PushTransition()
            case .main:
                return ModalTransition()
            case .register:
//                return ModalTransition(animated: true, animator: FadeAnimator())
//                return ModalTransition()
                return PushTransition()
            }
        }
    }
    
    struct Storage {
        var phoneNumber: String = ""
    }
    
    
    private var router: Router
    private var childCoordinators = [Coordinator]()
    private var currentState = State.auth
    private var moduleFactory: ModuleFactory
    private var storage = Storage()
    
    init(router: Router) {
        self.router = router
        moduleFactory = ModuleFactory()
    }
    
    func start() {
        let controller = makeController()
//        router.navigationController.pushViewController(controller, animated: false)
        router.open(viewController: controller, transition: PushTransition())
//        changeState(to: currentState)
    }
    
    private func changeState(to state: State) {
        currentState = state
        let controller = makeController()
        
        router.open(viewController: controller, transition: state.transition)
    }
    
    private func backAction() {
        router.closeLast()
    }
    
    private func moveBack(to state: State) {
        if let module = router.modules.filter({getState(for: $0) == state}).last {
            router.back(to: module)
        }
    }
    
    private func getState(for viewController: UIViewController) -> State {
        switch viewController {
        case is AuthViewController:
            return .auth
        case is SignUpViewController:
            return .register
        case is ForgotPasswordViewController:
            return .forgotPassword
        case is ProfileViewController:
            return .profile
        default:
            return .main
        }
    }
    
    func makeController() -> PresentableModule {
        switch currentState {
        case .auth:
            return moduleFactory.makeAuthController { (state) in
                
                switch state {
                    
                case .login:
                    self.changeState(to: .auth)
                case .signup:
                    self.changeState(to: .register)
                case .forgotPassword:
                    self.changeState(to: .forgotPassword)
                case .success:
                    self.changeState(to: .profile)
                }
            }
        case .register:
            return moduleFactory.makeSignUpController { (state) in
                switch state {
                    
                case .profile:
                    self.changeState(to: .profile)
                case .login:
                    self.changeState(to: .auth)
                case .forgotPassword:
//                    self.changeState(to: .forgotPassword)
                    self.backAction()
                }
            }
        case .forgotPassword:
            return moduleFactory.makeForgotPasswordController { (state) in
                switch state {
                    
                case .success:
                    self.changeState(to: .auth)
                }
            }
        case .profile:
            return moduleFactory.makeProfileController { (state) in
                switch state {

                case .success:
                    self.moveBack(to: .auth)
//                    self.changeState(to: .main)

                }
            }
        case .main:
            return BaseViewController()
        }
    }
}
