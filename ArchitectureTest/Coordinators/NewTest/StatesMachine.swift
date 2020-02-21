//
//  StatesMachine.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 21.02.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import UIKit

class StateHolder<T: CoordinatorState> {
    var state: T
    var controller: UIViewController
    var transition: Transition
    
    init(state: T, controller: UIViewController, transition: Transition) {
        self.state = state
        self.controller = controller
        self.transition = transition
    }
}

class StatesMachine<T: CoordinatorState> {
    
    private var array = [StateHolder<T>]() {
        didSet {
            print("array got \(array.count) elemtns = \(array.map({$0.controller}))")
        }
    }
    
    var count: Int {
        return array.count
    }
    
    func push(_ state: StateHolder<T>) {
        array.append(state)
    }
    
    func pop() {
        array.removeLast()
    }
    
    func popTo(_ viewController: UIViewController) {
        if let index = array.lastIndex(where: { $0.controller === viewController }) {
            let removing = array.count - index - 1
            array.removeLast(removing)

        }
    }
    
    func element(index: Int) -> StateHolder<T> {
        return array[index]
    }
    
    func lastElement(_ controller: UIViewController) -> StateHolder<T>? {
        return array.last(where: { $0.controller === controller })
    }
    
    func lastElement(_ state: T) -> StateHolder<T>? {
        return array.last(where: { $0.state == state})
    }
    
    var currentState: StateHolder<T>? {
        return array.last
    }
    
    var previousState: StateHolder<T>? {
        guard array.count >= 2 else { return nil }
        
        return array[array.count - 2]
    }

}
