//
//  LoginViewController.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol ProfileViewControllerFactoryType {
    func makeProfileController(completion: ((_ state: ProfileViewController.FinishState) -> Void)?) -> UIViewController
}

extension ProfileViewControllerFactoryType {
    func makeProfileController(completion: ((ProfileViewController.FinishState) -> Void)?) -> UIViewController {
        let controller = ProfileViewController()
        controller.onComplete = completion
        return controller
    }
}

class ProfileViewController: BaseViewController {
    
    enum FinishState {
        case success
        case picture
    }
    
    var onComplete: ((_ state: FinishState) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.append(createButton(title: "picture", tagert: self, action: #selector(first)))
        buttons.append(createButton(title: "success", tagert: self, action: #selector(third)))
    }
    
    @objc func third() {
        onComplete?(FinishState.success)
    }
    
    @objc func first() {
           onComplete?(FinishState.picture)
       }
    
    
}

