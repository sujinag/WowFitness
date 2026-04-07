//
//  DatabasePersistent.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 04/11/25.
//

import Foundation
import CoreData

class DatabasePersistent {
    static let shared = DatabasePersistent()  // Singleton instance

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "Records")  // Load Core Data model
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    // Provide easy access to Core Data's context (used to fetch, save, delete data)
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // Save changes to the database
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
