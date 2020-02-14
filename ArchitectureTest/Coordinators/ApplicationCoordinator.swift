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

class Router: NSObject {
    //    func present(module: Presentable?)
    //    func dismiss(module: Presentable?)
    //
    //    func push(module: Presentable?)
    //    func pop(module: Presentable?)
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        navigationController.delegate = self
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("Navigation controller did show \(viewController)")
//        guard let popedViewCOntroller = navigationController.transitionCoordinator?.view(forKey: .from),
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("Navigation controller will show \(viewController)")
    }
//    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//
//        // Ensure the view controller is popping
//        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(poppedViewController) else {
//            return
//        }
//        runCompletion(for: poppedViewController)
//    }
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
//        let controller = getInitialController()
//        createWindow(with: controller)
        
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
