//
//  signupController.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//


import UIKit

protocol InitialViewControllerDelegate: class {
    func onComplete(_ controller: InitialViewController, state: InitialViewController.FinishState)
}

protocol InitialViewControllerFactoryType {
    func makeInitialController(delegate: InitialViewControllerDelegate?) -> UIViewController
}

extension InitialViewControllerFactoryType {
    func makeInitialController(delegate: InitialViewControllerDelegate?) -> UIViewController {
        let controller = InitialViewController()
        controller.delegate = delegate
        return controller
    }
}

class InitialViewController: BaseViewController {
    
    enum FinishState {
        case test1
        case test2
        case toFinish
    }
    
    weak var delegate: InitialViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.append(createButton(title: "test1", tagert: self, action: #selector(first)))
        buttons.append(createButton(title: "test2", tagert: self, action: #selector(second)))
        buttons.append(createButton(title: "toFinish", tagert: self, action: #selector(third)))
    }
    
    @objc func first() {
        delegate?.onComplete(self, state: .test1)
    }
    
    @objc func second() {
        delegate?.onComplete(self, state: .test2)
    }
    
    @objc func third() {
        delegate?.onComplete(self, state: .toFinish)
    }
    
    
}

