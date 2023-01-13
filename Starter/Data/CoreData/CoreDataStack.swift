//
//  CoreDataStack.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/03/2022.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    static let shared = CoreDataStack()
    
    var persistentContainer = NSPersistentContainer(name: "MovieDB")
    
    var context: NSManagedObjectContext {
        get {
            persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            return persistentContainer.viewContext
        }
    }
    
    private override init() {
        persistentContainer = NSPersistentContainer(name: "MovieDB")
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
