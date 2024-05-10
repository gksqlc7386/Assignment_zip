//
//  CoreDataManager.swift
//  Assignment_7
//
//  Created by Luz on 5/10/24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    // MARK: - properties
    
    static let shared: CoreDataManager = CoreDataManager()
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is not accessible.")
        }
        return appDelegate
    }
    
    private var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - methods
    
    func saveBook(title: String, author: String, price: Int64) {
        let entity = NSEntityDescription.entity(forEntityName: "WishData", in: managedContext)!
        let wish = NSManagedObject(entity: entity, insertInto: managedContext)
        
        wish.setValue(title, forKeyPath: "title")
        wish.setValue(author, forKeyPath: "author")
        wish.setValue(price, forKeyPath: "price")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error.localizedDescription)")
        }
    }
    
    func fetchWishItems() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WishData")
        
        do {
            let wishes = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return wishes
        } catch let error as NSError {
            print("Could not fetch: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteWish(wish: NSManagedObject) {
        managedContext.delete(wish)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete: \(error.localizedDescription)")
        }
    }
    
    func deleteAllWishes() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WishData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete all wishes: \(error.localizedDescription)")
        }
    }

    
}

