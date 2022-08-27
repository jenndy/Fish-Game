//
//  CoreDataStack.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 12/1/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack: NSObject {
    
    static let shared = CoreDataStack()
    
    let modelName = "Pet_Add_One"
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Pet_Add_One")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var fish: [NSManagedObject] = []
    
    // MARK: - Core Data operations
    
    func update() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fish")
        do {
            fish = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
    }
    
//    func saveEntry(name: String, type: String, score: Int, image: String) {
//        
//        if let entity = NSEntityDescription.entity(forEntityName: "Fish", in: context){
//            print("begin")
//            let entry = NSManagedObject(entity: entity, insertInto: context)
//            if name != nil {
//                entry.setValue(name, forKeyPath: "name")
//            }
//            if type != nil {
//                entry.setValue(type, forKeyPath: "type")
//            }
//            if score != nil {
//                entry.setValue(score, forKeyPath: "score")
//            }
//            if image != nil {
//                entry.setValue(image, forKeyPath: "image")
//            }
//            
//            do {
//                try context.save()
//            } catch let error as NSError {
//                print("Could not save the entry. \(error), \(error.userInfo)")
//            }
//            print("done")
//        }
//        
//        update()
//    }
    
    func deleteItem(item: Fish) {
        if let _ = fish.firstIndex(of: item)  {
            context.delete(item)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not delete the item. \(error), \(error.userInfo)")
            }
        }
        update()
    }
    
    func saveContext () {
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

