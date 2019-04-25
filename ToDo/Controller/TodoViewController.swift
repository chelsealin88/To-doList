//
//  ViewController.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/4/15.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var addtextField: UITextField!
    
    let center : NotificationCenter = NotificationCenter.default
    var coredata = CoreData()
    var status = true
    
    var list : [ToDo] {
        ///todo: lazy
        return coredata.list//.map{$0.atodo}
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //        navigationItem.title =
        
        setButton()
        addtextField.layer.cornerRadius = addtextField.frame.height / 2
        addtextField.clipsToBounds = true
        //change attribute name
        coredata.list.forEach{
            $0.renameAttribute(before: "enter", after: "title")
        }
        
        //Listion to keyboard
        
        center.addObserver(self, selector: #selector(keyboardWillChange(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        addtextField.delegate = self
    }
    
    // Stop to listen keyboard notification
    deinit {
        center.addObserver(self, selector: #selector(keyboardWillChange(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
    // get data from your persistent store
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func addTodoButton(_ sender: Any) {
        
        guard let todotext = addtextField.text, !todotext.isEmpty else {
            return
        }
        self.save(title: todotext)
        self.tableView.reloadData()
        addtextField.text = ""
        
    }
    
    // Get Cora Data
    func getData() {
        coredata.getData {
            ///todo gcd
            tableView.reloadData()
        }
    }
    
    // Save Core Data
    func save(title: String) {
        coredata.saveData(title: title)
    }
    
    
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
    
    //keyboard
    @objc func keyboardWillChange(noti: Notification) {
        print("keyboard will change \(noti.name.rawValue)")
        view.frame.origin.y = -300
        /// todo: keyboard heigh
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


// MARK: TableView DataSource
extension TodoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let aTodo = list[indexPath.row]
        
//        cell.textLabel?.attributedText = aTodo.title.strikeThrough(bool: aTodo.done)
        cell.textLabel?.attributedText = aTodo.title?.strikeThrough(bool: aTodo.done)
        
    
    
        if aTodo.done {
            cell.textLabel?.attributedText =  strikeThroughText(aTodo.title!)
        }
        
        return cell
        
    }
}


// Swipe
extension TodoViewController: UITableViewDelegate {
    
    
    // Done
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let atodo = self.list[indexPath.row]
        let needAttribute = atodo.done // true刪除線
        let cell = tableView.cellForRow(at: indexPath)
        let title = atodo.title
        
        if needAttribute ==  false {
            
            
            let doneAction = UIContextualAction(style: .normal, title: "Done", handler: { (action, view, completion) in
                
                self.coredata.list[indexPath.row].setValue(!atodo.done, forKey: "done")
                try! self.coredata.appDelegate.persistentContainer.viewContext.save()
//                self.coredata.refresh()
                cell?.textLabel?.attributedText = atodo.title!.strikeThrough(bool: !needAttribute)
                
                
                completion(true)
            })
            
            doneAction.backgroundColor = .init(red: 58/235, green: 132/235, blue: 189/235, alpha: 1)
            return UISwipeActionsConfiguration(actions: [doneAction])
            
        } else {
            
            
            
            let undoAction = UIContextualAction(style: .normal, title: "Undo", handler: { (action, view, completion) in
                
                self.coredata.list[indexPath.row].setValue(!atodo.done, forKey: "done")
                try! self.coredata.appDelegate.persistentContainer.viewContext.save()
//                self.coredata.refresh()
                cell?.textLabel?.attributedText = atodo.title!.strikeThrough(bool: !needAttribute)
                
                completion(true)
                
            })
            
            undoAction.backgroundColor = .init(red: 181/255, green: 204/255, blue: 232/255, alpha: 1)
            return UISwipeActionsConfiguration(actions: [undoAction])
        }
        
    }
    
    
    // Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            
            if self.status == true {
                
                let alert = UIAlertController(title: "Are you sure to delete?", message: "", preferredStyle: .alert)
                let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
                let deletetAction = UIAlertAction(title: "Delete", style: .default) { (alert) in
                    
                    let managedContext = self.coredata.appDelegate.persistentContainer.viewContext
                    self.coredata.managedContext.delete(self.coredata.list[indexPath.row])
                    
                    do {
                        try managedContext.save()
                        self.getData()
                    } catch let error as NSError {
                        print("Could not delete \(error), \(error.userInfo)")
                    }
                    completion(true)
                }
                alert.addAction(cancleAction)
                alert.addAction(deletetAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        action.backgroundColor = .init(red: 121/235, green: 121/235, blue: 130/235, alpha: 1)
        return UISwipeActionsConfiguration(actions: [action])
        
        
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /// Usage:
    /// let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
    /// let color2 = UIColor(rgb: 0xFFFFFF)
    ///
    /// - Parameter rgb: 0xFFFFFF
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension String {
    
    func strikeThrough(bool: Bool) -> NSAttributedString {
        
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        
        if bool == true {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        }
        
        return attributeString
    }
    
}
