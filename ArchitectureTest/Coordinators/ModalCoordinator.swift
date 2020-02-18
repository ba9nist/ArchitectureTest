//
//  ModalCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 18.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol ModalCoordinatorDeleate: class {
    func onComplete(_ coordinator: ModalCoordinator, state: ModalCoordinator.FinishState)
}

protocol ModalCoordinatorFactoryType {
    func makeModalCoordinator(router: Router, delegate: ModalCoordinatorDeleate? ) -> Coordinator
}

class ModalCoordinatorFactory: ModalCoordinatorFactoryType {
    func makeModalCoordinator(router: Router, delegate: ModalCoordinatorDeleate?) -> Coordinator {
        let coordinator = ModalCoordinator(router: router)
        coordinator.completionDelegate = delegate
        return coordinator
    }
}

class ModalCoordinator: Coordinator {
    class ModuleFactory: InitialViewControllerFactoryType & FinishViewControllerFactoryType {}
    
    enum FinishState {
        case success
        case cancel
    }
    
    enum State {
        case initial
        case finish
        case test1
        case test2
        
        var transition: Transition {
             return PushTransition()
        }
    }
    
    struct StateRelation {
        var state: State
        var module: UIViewController
    }

    struct Storage {
        var phoneNumber: String = ""
    }
    
    weak var completionDelegate: ModalCoordinatorDeleate?
    var rootViewController: UINavigationController
    
    private var controllerMap: [StateRelation] = []
    
    private var presentedFrom: Router
    private var router: Router
    private var childCoordinators = [Coordinator]()
    private var currentState = State.initial
    private var moduleFactory: ModuleFactory
    private var storage = Storage()
    
    init(router: Router) {
        self.presentedFrom = router
        rootViewController = UINavigationController()
        self.router = Router(navigationController: rootViewController)
        moduleFactory = ModuleFactory()
    }
    
    func start() {
        
        moveForward(to: currentState)
        rootViewController.modalPresentationStyle = .fullScreen
        
        presentedFrom.navigationController.present(rootViewController, animated: true, completion: nil)
    }
    
    func finishCoordinator() {
        rootViewController.dismiss(animated: true, completion: nil)
    }
    
    private func moveForward(to state: State) {
        currentState = state
        
        if let controller = controllerMap.filter({$0.state == state}).first?.module {
            let removedCount = router.back(to: controller)
            controllerMap.removeLast(removedCount)
            print(controllerMap)
        } else {
            let controller = makeController()
            router.open(viewController: controller, transition: state.transition)
            print(controllerMap)
        }
        
    }
    
//    private func moveBack(to state: State) {
//        if let module = router.modules.filter({getState(for: $0) == state}).last {
//            router.back(to: module)
//        }
//    }
    
    func makeController() -> UIViewController {
        var controller = UIViewController()
        switch currentState {
        case .initial:
            controller = moduleFactory.makeInitialController(delegate: self)
        case .finish:
            controller = moduleFactory.makeFinishController(delegate: self)
        case .test2, .test1:
            controller = BaseViewController()
        }
        
        controllerMap.append(ModalCoordinator.StateRelation(state: currentState, module: controller))
        return controller
    }
    
    
}

extension ModalCoordinator: InitialViewControllerDelegate {
    func onComplete(_ controller: InitialViewController, state: InitialViewController.FinishState) {
        switch state {
            
        case .test1:
            moveForward(to: .test1)
        case .test2:
            moveForward(to: .test2)
        case .toFinish:
            moveForward(to: .finish)
        }
    }
    
    
}

extension ModalCoordinator: FinishViewControllerDelegate {
    func onComplete(_ controller: FinishViewController, state: FinishViewController.FinishState) {
        switch state {
            
        case .success:
            completionDelegate?.onComplete(self, state: .success)
            self.finishCoordinator()
        case .cancel:
            completionDelegate?.onComplete(self, state: .cancel)
            self.finishCoordinator()
        case .back:
            self.moveForward(to: .initial)
        }
    }
    
    
}

extension ModalCoordinator: RouterDelegate {
    func didRemoveModules() {
        
    }
    
}
