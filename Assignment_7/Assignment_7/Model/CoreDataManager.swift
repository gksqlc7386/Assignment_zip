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
    
    // MARK: - methods (WishData)
    
    func saveBook(title: String, author: String, price: Int64) {
        let entity = NSEntityDescription.entity(forEntityName: "WishData", in: managedContext)!
        let wish = NSManagedObject(entity: entity, insertInto: managedContext)
        
        wish.setValue(title, forKeyPath: "title")
        wish.setValue(author, forKeyPath: "author")
        wish.setValue(price, forKeyPath: "price")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save WishBook: \(error.localizedDescription)")
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
    
    // MARK: - methods (RecentData)
    
    func saveRecentBook(title: String, author: String, thumbnail: String) {
        let entity = NSEntityDescription.entity(forEntityName: "RecentData", in: managedContext)!
        let recent = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recent.setValue(title, forKeyPath: "title")
        recent.setValue(author, forKeyPath: "author")
        recent.setValue(thumbnail, forKeyPath: "thumbnail")
        
        do {
            try managedContext.save()
            print("recentBook saved")
        } catch let error as NSError {
            print("Could not save recentBook: \(error.localizedDescription)")
        }
    }
    
    func fetchRecentItems() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentData")
        
        do {
            let recentBooks = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return recentBooks
        } catch let error as NSError {
            print("Could not fetch recentBooks: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteAllRecentBooks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete all recentBooks: \(error.localizedDescription)")
        }
    }
}

