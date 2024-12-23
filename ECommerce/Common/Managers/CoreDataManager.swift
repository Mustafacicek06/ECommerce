//
//  CoreDataManager.swift
//  ECommerce
//
//  Created by Mustafa Çiçek on 23.12.2024.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {} // Singleton

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ECommerce") // Data Model adı
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Generic CRUD Operations

    // Fetch All Entities
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)

        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            return fetchedObjects
        } catch {
            print("Failed to fetch \(entityName): \(error.localizedDescription)")
            return []
        }
    }

    // Insert Entity
    func insert<T: NSManagedObject>(_ objectType: T.Type, configure: (T) -> Void) {
        let entityName = String(describing: objectType)
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Entity \(entityName) not found")
        }

        let object = T(entity: entity, insertInto: context)
        configure(object)
        saveContext()
    }
    
    // Update
    
    func update<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate, configure: (T) -> Void) {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            let objectsToUpdate = try context.fetch(fetchRequest)
            for object in objectsToUpdate {
                configure(object)
            }
            saveContext()
        } catch {
            print("Failed to update \(entityName): \(error.localizedDescription)")
        }
    }

    // Delete Entity by Predicate
    func delete<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil) {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
            let objectsToDelete = try context.fetch(fetchRequest)
            for object in objectsToDelete {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Failed to delete \(entityName): \(error.localizedDescription)")
        }
    }

    // Check Existence
    func exists<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate) -> Bool {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check existence for \(entityName): \(error.localizedDescription)")
            return false
        }
    }
}
