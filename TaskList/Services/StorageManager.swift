//
//  StorageManager.swift
//  TaskList
//
//  Created by Roman Lantsov on 03.04.2023.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
        
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private init() {}
    
    //MARK: - Fetch Data
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return taskList
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
