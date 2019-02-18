//
//  CoreDataManager.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 14/02/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ListOfNews")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        })
        return container
    }()
}
