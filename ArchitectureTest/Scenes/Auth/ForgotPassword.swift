//
//  ForgotPassword.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol ForgotPasswordViewControllerFactoryType {
    func makeForgotPasswordController(completion: ((_ state: ForgotPasswordViewController.FinishState) -> Void)?) -> UIViewController
}

extension ForgotPasswordViewControllerFactoryType {
    func makeForgotPasswordController(completion: ((ForgotPasswordViewController.FinishState) -> Void)?) -> UIViewController {
        let controller = ForgotPasswordViewController()
        controller.onComplete = completion
        return controller
    }
}

class ForgotPasswordViewController: BaseViewController {
    
    enum FinishState {
        case success
    }
    
    var onComplete: ((_ state: FinishState) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.append(createButton(title: "success", tagert: self, action: #selector(success)))
    }
    
    @objc func success() {
        onComplete?(FinishState.success)
    }
}

