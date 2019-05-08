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
    
//    var list : [NSManagedObject] = []
    var list : [ToDo] = []
    var categoryList : [Category] = []
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    
    // save list Dat
    func saveData(title: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        let todo = managedObject as! ToDo
        todo.title = title
        todo.done = false
//        todo.id = Int64(list.count)
        
        do {
            try managedContext.save()
            list.append(todo)
        } catch let error as NSError {
            fatalError("\(error)")
        }
        
    }
    
    func save()throws{
           try managedContext.save()
    }
    
    // Save Catagory
    func saveCategory(category: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        let categoryObject = object as! Category
        categoryObject.name = category
        
        do {
            try managedContext.save()
            categoryList.append(categoryObject)
        } catch let error as NSError {
            fatalError("Error:\(error)")
        }
    }

    
    
    typealias Completion = () -> Void
    
    func getCategoryData(completion: Completion) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        do {
            categoryList = try managedContext.fetch(fetchRequest) as! [Category]
        } catch let error as NSError {
            fatalError("Error:\(error)")
        }
        
        completion()
    }

    //Make Todo
    func makeTodo(title:String) -> ToDo {
        
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        let todo = managedObject as! ToDo
        todo.title = title
        todo.done = false
        return todo
    }
    

    func getData(completion: Completion) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
        
        do {
            list = try managedContext.fetch(fetchRequest) as! [ToDo]
        } catch let error as NSError {
            fatalError("Error:\(error)")
        }
        
        completion()

    }
}

extension NSManagedObject {

//    var atodo: Atodo {
//        let title: String = value(forKey: "title") as! String
//        let done: Bool = value(forKey: "done") as! Bool
//        return Atodo.init(title: title, done: done)
//    }
    
    func renameAttribute(before: String, after: String) {

        try! managedObjectContext?.save()
    }
}

extension Category {
    
    var todolist : [ToDo] {
        
        return todos?.allObjects.map({$0 as! ToDo}).sorted{
            $0.id > $1.id
            } ?? [] //return 空陣列
        
    }
    
    var categoryCount : Int {
        
        return todolist.filter({ (todo) -> Bool in
            !todo.done
        }).count 
        
    }
    
   
    
}


// View Model
//struct Atodo {
//    var title: String
//    var done: Bool
//}

//todo : 把CoreData當Model來要資料
