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
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    
    private init() {}
    
    func createNewTask(withName name: String) -> Task {
        let task = Task(context: context)
        task.title = name
        saveContext()
        return task
    }
    
    func updateTask(_ task: Task, on taskName: String) {
        task.title = taskName
        saveContext()
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        
        do {
            taskList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return taskList
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
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
