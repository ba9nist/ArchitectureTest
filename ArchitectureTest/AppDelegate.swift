//
//  AppDelegate.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 15.01.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    let applicationCoordinator = ApplicationCoordinator(router: Router(navigationController: UINavigationController()))
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationCoordinator.start()
        return true
    }

}

