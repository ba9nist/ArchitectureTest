//
//  ApplicationCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 20.01.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController
}

class ApplicationCoordinator: Coordinator {
    
    enum State {
        case authorization
    }
    
    var window: UIWindow?
    private var router: Router
    private var state: State = .authorization
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        createWindow(with: router.navigationController)
        
        switch state {
        case .authorization:
            let authorizationCoordinator = AuthorizationCoordinator(router: router)
            authorizationCoordinator.start()
        }
    }
    
    private func getInitialController() -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .green
        return controller
    }
    
    private func createWindow(with controller: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}
