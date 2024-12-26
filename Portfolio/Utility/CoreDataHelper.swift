//
//  CoreDataHelper.swift
//  Upstox
//
//  Created by Lucifer on 27/12/24.
//

import UIKit
import CoreData

final class CoreDataHelper {
    static let shared = CoreDataHelper()
        
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
}

// MARK: Helper
extension CoreDataHelper {
    func saveData(entityName: String, paths: [String: Any]) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                      in: context) else { return }
        let object = NSManagedObject(entity: entity, insertInto: context)
        paths.forEach { key, value in
            object.setValue(value, forKey: key)
        }

        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetchData<T: NSManagedObject>() -> [T] {
        var result = [T]()
        do {
            result = try context.fetch(T.fetchRequest()) as? [T] ?? []
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return result
    }

    func deleteData(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
