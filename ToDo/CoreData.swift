//
//  CoreData.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/4/17.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import Foundation
import CoreData
import UIKit.UIApplication


class CoreData {
    
    var list : [NSManagedObject] = []
    
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveData(title: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
        let listObject = NSManagedObject(entity: entity, insertInto: managedContext)
        listObject.setValue(enter, forKey: "title")
        listObject.setValue(false, forKey: "done")
        
        // update all data
        for index in list {
            if index.value(forKeyPath: "done") as? Bool == nil {
                index.setValue(false, forKey: "done")
            }
        }
        
        do {
            try managedContext.save()
            list.append(listObject)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    typealias Completion = () -> Void
    
    func getData(completion: Completion) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
        
        do {
            list = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        completion()
        
    }
}

extension NSManagedObject {
    var atodo: Atodo {
        
        let title: String = value(forKey: "title") as! String
//        print(value(forKey: "enter") as? String)
        let done: Bool = value(forKey: "done") as! Bool
        
        return Atodo.init(title: title, done: done)
    }
    func renameAttribute(before: String, after: String) {
        
//        let previousValue = value(forKey: before)
//        setValue(previousValue, forKey: after)
//        setValue(nil, forKey: before)
        try! managedObjectContext?.save()
    }
}


struct Atodo {
    
    var title: String
    var done: Bool
    
}
