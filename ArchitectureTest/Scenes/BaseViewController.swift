//
//  BaseViewController.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 13.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(type(of: self))"
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    private func setupView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
    }
    
    public func createButton(title: String, tagert: Any?, action: Selector)  -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(tagert, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        return button
    }

}
