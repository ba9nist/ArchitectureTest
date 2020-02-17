//
//  Transition.swift
//  Routing
//
//  Created by Nikita Ermolenko on 29/09/2017.
//

import Foundation
import UIKit

protocol Transition: class {
    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}

class BaseTransition: NSObject, Transition {
    weak var viewController: UIViewController?
    
    var animator: Animator?
    var animated: Bool = true
    
    init(animator: Animator?, animated: Bool = true) {
        self.animator = animator
        self.animated = animated
    }
    
    func open(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func close(_ viewController: UIViewController) {
        
    }
}
