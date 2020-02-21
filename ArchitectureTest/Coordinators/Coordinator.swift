//
//  Coordinator.swift
//  ArchitectureTest
//
//  Created by Yevhenii Boryspolets on 20.01.2020.
//  Copyright © 2020 Yevhenii Boryspolets. All rights reserved.
//

import Foundation

protocol CoordinatorState: Equatable {
    
}

protocol Coordinator {
    func start()
}
