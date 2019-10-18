//
//  Coordinator.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit
import CoreData

protocol CoordinatorProtocol: AnyObject {
    
    func startFlow()
    
}

final class Coordinator: CoordinatorProtocol {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
    }
    
    func startFlow() {
        
        let container = NSPersistentContainer(name: "CoreDataModelNews")
        
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
            
        }
        
        let storage = Storage(container: container)
        let api = API(storage: storage)
        let networkService = NetworkService(api: api)
        let viewModel = NewsViewModel(networkService: networkService)
        
        
        window.rootViewController = NewsListViewController(viewModel: viewModel)
        window.makeKeyAndVisible()
    }
    
}
