//
//  signupController.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//


import UIKit

protocol SignUpViewControllerFactoryType {
    func makeSignUpController(completion: ((_ state: SignUpViewController.FinishState) -> Void)?) -> PresentableModule
}

extension SignUpViewControllerFactoryType {
    func makeSignUpController(completion: ((SignUpViewController.FinishState) -> Void)?) -> PresentableModule {
        let controller = SignUpViewController()
        controller.onComplete = completion
        return controller
    }
}

class SignUpViewController: BaseViewController {
    
    enum FinishState {
        case profile
        case login
        case forgotPassword
    }
    
    var onComplete: ((_ state: FinishState) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.append(createButton(title: "profiel", tagert: self, action: #selector(profile)))
        buttons.append(createButton(title: "login", tagert: self, action: #selector(login)))
        buttons.append(createButton(title: "forgotPassword", tagert: self, action: #selector(forgotPassword)))
    }
    
    @objc func login() {
        onComplete?(FinishState.login)
    }
    
    @objc func profile() {
        onComplete?(FinishState.profile)
    }
    
    @objc func forgotPassword() {
        onComplete?(FinishState.forgotPassword)
    }
    
    
}

