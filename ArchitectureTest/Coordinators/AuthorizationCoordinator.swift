//
//  AuthorizationCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 12.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class AuthorizationCoordinator: Coordinator {
//    typealias ModuleFactory = TestViewControllerFactoryType & YelloTestViewControllerFactoryType
    class ModuleFactory: AuthViewControllerFactoryType & ProfileViewControllerFactoryType & SignUpViewControllerFactoryType & ForgotPasswordViewControllerFactoryType {}
    
    enum State {
        case auth
        case register
        case forgotPassword
        case profile
        case main
    }
    
    struct Storage {
        var phoneNumber: String = ""
    }
    
    
    private var router: Router
    private var viewControllers = [UIViewController]()
    private var childCoordinators = [Coordinator]()
    private var currentState = State.auth
    private var moduleFactory: ModuleFactory
    private var storage = Storage()
    
    init(router: Router) {
        self.router = router
        moduleFactory = ModuleFactory()
    }
    
    func start() {
        changeState(to: currentState)
    }
    
    private func changeState(to state: State) {
        currentState = state
        let controller = makeController()
        viewControllers.append(controller)
        
        router.navigationController.pushViewController(controller, animated: true)
    }
    
    private func backAction() {
        if viewControllers.count > 1 {
            router.navigationController.popViewController(animated: true)
            viewControllers.removeLast()
        } else {
            //finish coordinator
        }
    }
    
    func makeController() -> UIViewController {
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
                    self.changeState(to: .main)
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
                    self.changeState(to: .forgotPassword)
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
                    self.changeState(to: .main)

                }
            }
        case .main:
            return UIViewController()
        }
    }
}
