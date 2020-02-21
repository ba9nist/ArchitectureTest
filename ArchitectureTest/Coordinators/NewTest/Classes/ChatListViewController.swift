//
//  signupController.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol ChatListViewControllerDelegate: class {
    func onComplete(_ controller: ChatListViewController, state: ChatListViewController.FinishState)
}

protocol ChatListViewControllerFactoryType {
    func makeChatListController(delegate: ChatListViewControllerDelegate?) -> UIViewController
}

extension ChatListViewControllerFactoryType {
    func makeChatListController(delegate: ChatListViewControllerDelegate?) -> UIViewController {
        let controller = ChatListViewController()
        controller.delegate = delegate
        return controller
    }
}

class ChatListViewController: BaseViewController {
    
    enum FinishState {
        case success
        case back
        case cancel
    }
    
    weak var delegate: ChatListViewControllerDelegate?

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

