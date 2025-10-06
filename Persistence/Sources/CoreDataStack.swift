//
//  CoreDataStack.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/10/2025.
//

import Foundation
import CoreData

public final class CoreDataStack {
    
    @MainActor public static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "CashFlow")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
