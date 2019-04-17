//
//  ViewController.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/4/15.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var addtextField: UITextField!
    
//    var havetext = Bool()
    var list : [NSManagedObject] = [] {
        didSet {
            list.forEach { (obj) in
                print(obj)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setButton()
        addtextField.layer.cornerRadius = addtextField.frame.height / 2
        addtextField.clipsToBounds = true
        
    }
    
    // get data from your persistent store
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        
    }
    
    
    
    @IBAction func addTodoButton(_ sender: Any) {
        
        
        guard let todotext = addtextField.text, !todotext.isEmpty else {
            return
        }
        self.save(enter: todotext)
        self.tableView.reloadData()
        addtextField.text = ""
    
    }
    
    
    
    
    // Get Cora Data
    func getData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
        
        do {
            list = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    
    // Save Core Data
    func save(enter: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //  save or retrieve anything from your Core Data store
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
        let listObject = NSManagedObject(entity: entity, insertInto: managedContext)
        listObject.setValue(enter, forKey: "enter")
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
    
//    func done()
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func strikeThroughText (_ text:String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    
    func setButton() {
        
        addTodoButton.layer.cornerRadius = addTodoButton.frame.size.width / 2
        addTodoButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addTodoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addTodoButton.layer.shadowOpacity = 1.0
        addTodoButton.layer.shadowRadius = 0.0
        addTodoButton.layer.masksToBounds = false

    }
    
    
}




// MARK: TableView DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let lists = list[indexPath.row]
        cell.textLabel?.text = lists.value(forKeyPath: "enter") as? String
        let done = lists.value(forKeyPath: "done") as! Bool
        if done {
            cell.textLabel?.attributedText = strikeThroughText((lists.value(forKeyPath: "enter") as? String)!)
        }
        
        
        return cell
        
    }
}


// Swipe
extension ViewController: UITableViewDelegate {
    
    
    // Done
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
            
            let lists = self.list[indexPath.row]
            let index = tableView.cellForRow(at: indexPath)
            let strikeString = self.list[indexPath.row].value(forKey: "enter") as? String
            index?.textLabel?.attributedText = self.strikeThroughText(strikeString!)
            guard let currentBool = lists.value(forKey: "done") as? Bool else { return }
            lists.setValue(!currentBool, forKey: "done")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            //  save or retrieve anything from your Core Data store
            try! appDelegate.persistentContainer.viewContext.save()
            completion(true)
            
        }
        
        action.backgroundColor = .init(red: 58/235, green: 132/235, blue: 189/235, alpha: 1)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    
    // Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(self.list[indexPath.row])
            
            do {
                try managedContext.save()
                self.getData()
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            completion(true)
            
        }
        
        action.backgroundColor = .init(red: 121/235, green: 121/235, blue: 130/235, alpha: 1)
        return UISwipeActionsConfiguration(actions: [action])
        
        
    }
}


extension UIButton {
    
    func changingButton(_ button: inout UIButton ) {
        self.isEnabled = false
        button.isEnabled = true
    }
    
}
