//
//  signupController.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol ChatViewControllerDelegate: class {
    func onComplete(_ controller: ChatViewController, state: ChatViewController.FinishState)
}

protocol ChatViewControllerFactoryType {
    func makeChatController(delegate: ChatViewControllerDelegate?) -> UIViewController
}

extension ChatViewControllerFactoryType {
    func makeChatController(delegate: ChatViewControllerDelegate?) -> UIViewController {
        let controller = ChatViewController()
        controller.delegate = delegate
        return controller
    }
}

class ChatViewController: BaseViewController {
    
    enum FinishState {
        case success
        case back
        case cancel
    }
    
    weak var delegate: ChatViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.append(createButton(title: "success", tagert: self, action: #selector(first)))
        buttons.append(createButton(title: "back", tagert: self, action: #selector(second)))
        buttons.append(createButton(title: "cancel", tagert: self, action: #selector(third)))
    }
    
    @objc func first() {
        delegate?.onComplete(self, state: .success)
    }
    
    @objc func second() {
        delegate?.onComplete(self, state: .back)
    }
    
    @objc func third() {
       delegate?.onComplete(self, state: .cancel)
   }
    
}

