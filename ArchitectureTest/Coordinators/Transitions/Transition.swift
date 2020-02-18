//
//  Transition.swift
//  Routing
//
//  Created by Nikita Ermolenko on 29/09/2017.
//

import Foundation
import UIKit

protocol Transition: class {
    var animator: Animator? { get }
    var animated: Bool { get }
}

class PushTransition: Transition {
    var animator: Animator?
    var animated: Bool
    
    init(animated: Bool = true, animator: Animator? = nil) {
        self.animator = animator
        self.animated = animated
    }
}

class ModalTransition: Transition {
    var animator: Animator?
    var animated: Bool
    
    var transitionStyle: UIModalTransitionStyle
    var presentationStyle: UIModalPresentationStyle
    
    init(animated: Bool = true,
         animator: Animator? = nil,
         transitionStyle: UIModalTransitionStyle = .coverVertical,
         presentationStyle: UIModalPresentationStyle = .overFullScreen) {
        
        self.animator = animator
        self.animated = animated
        self.transitionStyle = transitionStyle
        self.presentationStyle = presentationStyle
        
    }
    
    
}
