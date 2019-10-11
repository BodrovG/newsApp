//
//  Coordinator.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    
    func startFlow()
    
}

final class Coordinator: CoordinatorProtocol {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
    }
    
    func startFlow() {
        window.rootViewController = NewsTableViewController()
        window.makeKeyAndVisible()
    }
    
}
