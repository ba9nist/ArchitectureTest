//
//  BaseSecondCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 21.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class BaseSecondCoordinator<T: CoordinatorState>: NSObject {
    
    var stateMachine: StatesMachine<T>
    var router: TestRouter<T>
    
    init(router: TestRouter<T>, stateMachine: StatesMachine<T>) {
        self.router = router
        self.stateMachine = stateMachine
        super.init()
    }
    
    func moveForward(to state: T) {
        let controller = makeController(for: state)
        router.open(controller, for: state, with: state.transition)
    }
    
    func goBack(to state: T) {
        router.goBack(to: state)
    }
    
    func goBack() {
        router.goBack()
    }
    
    func makeController(for state: T) -> UIViewController {
        return UIViewController()
    }
    
}
