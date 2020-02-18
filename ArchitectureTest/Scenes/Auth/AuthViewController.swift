//
//  AuthViewController.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol AuthViewControllerFactoryType {
    func makeAuthController(completion: ((_ state: AuthViewController.FinishState) -> Void)?) -> UIViewController
}

extension AuthViewControllerFactoryType {
    func makeAuthController(completion: ((AuthViewController.FinishState) -> Void)?) -> UIViewController {
        let controller = AuthViewController()
        controller.onComplete = completion
        
        return controller
    }
}

class AuthViewController: BaseViewController {
    
    enum FinishState {
        case login
        case signup
        case forgotPassword
        case success
    }
    
    var onComplete: ((_ state: FinishState) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.append(createButton(title: "login", tagert: self, action: #selector(login)))
        buttons.append(createButton(title: "signup", tagert: self, action: #selector(signup)))
        buttons.append(createButton(title: "forgotPassword", tagert: self, action: #selector(forgotPassword)))
        buttons.append(createButton(title: "success", tagert: self, action: #selector(forth)))
    }
    
    @objc func login() {
        onComplete?(FinishState.login)
    }
    
    @objc func signup() {
        onComplete?(FinishState.signup)
    }
    
    @objc func forgotPassword() {
        onComplete?(FinishState.forgotPassword)
    }
    
    @objc func forth() {
        onComplete?(FinishState.success)
    }
    
}
