//
//  FeedCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 21.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol CoordinatorState: Equatable {
    
}

class FeedCoordinator: Coordinator {
    
    class ModuleFactory: InitialViewControllerFactoryType & FinishViewControllerFactoryType {}

    enum State: CoordinatorState {
        case initial
        case finish
        case test1
        case test2
        
        var transition: Transition {
            switch self {
            case .finish:
                return ModalTransition(presentationStyle: .overFullScreen)
            //                return ModalTransition(animator: FadeAnimator())
            default:
                //            return PushTransition()
                return PushTransition(animated: true, animator: FadeAnimator())
            }
            
        }
    }
    
    struct Storage {
        var phoneNumber: String = ""
    }
    
    
    private var navigationController: UINavigationController
    private var childCoordinators = [Coordinator]()
    private var currentState = State.initial
    private var moduleFactory: ModuleFactory = ModuleFactory()
    private var storage = Storage()
    private var stateMachine = StatesMachine<State>()
    private var router: TestRouter<State>
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.router = TestRouter(navigationController: self.navigationController, stateMachine: self.stateMachine)
    }

    func start() {
        moveForward(to: currentState)
    }

    private func moveForward(to state: State) {
        currentState = state
        
        let controller = makeController()
        router.open(controller, for: state, with: state.transition)
    }
    
    private func goBack(to state: State) {
        router.goBack(to: state)
    }
    
    private func goBack() {
        router.goBack()
    }
    
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

        return controller
    }
}

extension FeedCoordinator: InitialViewControllerDelegate {
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

extension FeedCoordinator: FinishViewControllerDelegate {
    func onComplete(_ controller: FinishViewController, state: FinishViewController.FinishState) {
        switch state {

        case .success:
            break
        case .cancel:
            self.goBack()
        case .back:
            self.goBack(to: .initial)
        }
    }


}
