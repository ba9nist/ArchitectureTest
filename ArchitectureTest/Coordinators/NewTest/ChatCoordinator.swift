//
//  FeedCoordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 21.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

protocol ChatCoordinatorFactoryType {
    func makeChatCoordinator(navigation: UINavigationController) -> Coordinator
}

class ChatCoordinatorFactory: ChatCoordinatorFactoryType {
    func makeChatCoordinator(navigation: UINavigationController) -> Coordinator {
        let coordinator = ChatCoordinator(navigationController: navigation)
        return coordinator
    }
}

class ChatCoordinator: Coordinator {
    
    class ModuleFactory: ChatViewControllerFactoryType, ChatListViewControllerFactoryType, ChatUsersViewControllerFactoryType  {}
    
    class CoordinatorFactory {}
    
    enum State: CoordinatorState {
        case chatsList
        case chat
        case chatUsers
        
        var transition: Transition {
            switch self {
            case .chatsList:
                return PushTransition(animated: false)
            case .chat:
                return PushTransition(animated: true, animator: FadeAnimator())
            case .chatUsers:
                return ModalTransition()
            }
        }
    }
    
    struct Storage {
        
    }
    
    
    private var presentedController: UINavigationController
    private var navigationController: UINavigationController
    private var childCoordinators = [Coordinator]()
    private var currentState = State.chatsList
    private var moduleFactory: ModuleFactory = ModuleFactory()
    private var coordinatorFactory: CoordinatorFactory = CoordinatorFactory()
    private var storage = Storage()
    private var stateMachine = StatesMachine<State>()
    private var router: TestRouter<State>
    
    init(navigationController: UINavigationController) {
        self.presentedController = navigationController
        self.navigationController = UINavigationController()
        self.router = TestRouter(navigationController: self.navigationController, stateMachine: self.stateMachine)
    }
    
    func start() {
        moveForward(to: currentState)
        self.presentedController.present(self.navigationController, animated: true, completion: nil)
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
        switch currentState {
            
        case .chatsList:
            return moduleFactory.makeChatListController(delegate: self)
        case .chat:
            return moduleFactory.makeChatController(delegate: self)
        case .chatUsers:
            return moduleFactory.makeChatUsersController(delegate: self)
        }
    }
}

// MARK: - ChatListViewControllerDelegate
extension ChatCoordinator: ChatListViewControllerDelegate {
    func onComplete(_ controller: ChatListViewController, state: ChatListViewController.FinishState) {
        switch state {
            
        case .success:
            self.moveForward(to: .chat)
        case .back:
            self.goBack()
        case .cancel:
            //return coordinator
            self.goBack()
        }
    }
}

// MARK: - ChatViewControllerDelegate
extension ChatCoordinator: ChatViewControllerDelegate {
    func onComplete(_ controller: ChatViewController, state: ChatViewController.FinishState) {
        switch state {
            
        case .success:
            self.moveForward(to: .chatUsers)
        case .back:
            self.goBack()
        case .cancel:
            self.goBack()
        }
        
    }
}

// MARK: - ChatUsersViewControllerDelegate
extension ChatCoordinator: ChatUsersViewControllerDelegate {
    func onComplete(_ controller: ChatUsersViewController, state: ChatUsersViewController.FinishState) {
        switch state {
        case .success:
            self.goBack(to: .chatsList)
        case .back:
            self.goBack()
        case .cancel:
            self.goBack()
        }
    }
}
