//
//  ApplicationCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 20.01.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    
    enum State {
        case authorization
        case test
    }
    
    var window: UIWindow?
    private var router: Router
    private var state: State = .test
    private var coordinators = [Coordinator]()
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        createWindow(with: router.navigationController)
        
        switch state {
        case .authorization:
            let authorizationCoordinator = AuthorizationCoordinator(router: router)
            coordinators.append(authorizationCoordinator)
            authorizationCoordinator.start()
        case .test:
            let testCoordinator = FeedCoordinator(navigationController: router.navigationController)
            coordinators.append(testCoordinator)
            testCoordinator.start()
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
