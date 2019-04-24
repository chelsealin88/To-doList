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
import UIKit.NSAttributedString


class CoreData {
    
    var list : [NSManagedObject] = []
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    // save list Data
    func saveData(title: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
        let listObject = NSManagedObject(entity: entity, insertInto: managedContext)
        listObject.setValue(title, forKey: "title")
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
    
    // Save Catagory
    func saveCategory(category: Acategory) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        object.setValue(category, forKey: "name")
        
        do {
            try managedContext.save()
            list.append(object)
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



// View Model
struct Atodo {
    
    var title: String
    var done: Bool
    var attributeString: NSAttributedString {
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        
        if done == true {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        }
        
        return attributeString
    }
}
