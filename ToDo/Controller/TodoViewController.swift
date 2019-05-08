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
    var tasknumber = Int()
    var navigationTitle = String()
    var status = true
    var category: Category?
    var list : [ToDo] {
        ///todo: lazy
        return coredata.list//.map{$0.atodo}
    }
    var barButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        setupButton()
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
        setupBarItem()

    //        print(coredata.getTodoFor(categoryName: category?.name ?? "😃"))
        
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
        
        guard let todos = category?.todolist.filter({ (todo) -> Bool in
            return !todo.done
        }).count else { return }
        
        let todo = coredata.makeTodo(title: title)
        todo.id = Int64(category!.todolist.count)
        category?.addToTodos(todo)
        barButton?.title = "\(todos + 1)"
        try! coredata.save()
    
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func strikeThroughText (_ text:String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    func setupBarItem() {
        //title
        navigationItem.title = navigationTitle
        
        // taks number
        guard let todos = category?.todolist.filter({ (todo) -> Bool in
            return !todo.done
        }).count else { return }
        tasknumber = todos
        barButton = UIBarButtonItem(title: "\(tasknumber)", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = barButton

        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 32)!], for: UIControl.State.normal)
        

    }
    
    /// todo: task number action
    @objc func addTapped() {
        
    }
    
    
    func setupButton() {
        addTodoButton.layer.cornerRadius = addTodoButton.frame.size.width / 2
        addTodoButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addTodoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addTodoButton.layer.shadowOpacity = 1.0
        addTodoButton.layer.shadowRadius = 0.0
        addTodoButton.layer.masksToBounds = false
    }

    //Setting keyboard
    @objc func keyboardWillChange(noti: Notification) {
        print("keyboard will change \(noti.name.rawValue)")
        guard let getkeyboardheigh = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { fatalError() }
        let frame = getkeyboardheigh.cgRectValue
        let height = frame.height
        
        view.frame.origin.y = -height
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
        return category?.todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let todos = category?.todos else { return .init() }
        guard let aTodo = category?.todolist[indexPath.row] else { return .init() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
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
                cell?.textLabel?.attributedText = atodo.title!.strikeThrough(bool: !needAttribute)
                
                completion(true) 
            })
            
            doneAction.backgroundColor = UIColor(red: 58, green: 132, blue: 189)
            return UISwipeActionsConfiguration(actions: [doneAction])
            
        } else {
            
            let undoAction = UIContextualAction(style: .normal, title: "Undo", handler: { (action, view, completion) in
                
                self.coredata.list[indexPath.row].setValue(!atodo.done, forKey: "done")
                try! self.coredata.appDelegate.persistentContainer.viewContext.save()
                cell?.textLabel?.attributedText = atodo.title!.strikeThrough(bool: !needAttribute)
                
                completion(true)
                
            })
            
            undoAction.backgroundColor = UIColor(red: 181, green: 204, blue: 232)
            return UISwipeActionsConfiguration(actions: [undoAction])
        }
        
    }
    
    
    // Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            
//            var todoTitle = String()
//            let atodo = self.list[indexPath.row]
//            todoTitle = atodo.title!
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
//            vc.todoTitle = todoTitle
        
            
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            
            if self.status == true {
                
                let alert = UIAlertController(title: "Are you sure to delete?", message: "", preferredStyle: .alert)
                let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
                let deletetAction = UIAlertAction(title: "Delete", style: .default) { (alert) in
                    
                    let managedContext = self.coredata.appDelegate.persistentContainer.viewContext
                    self.coredata.managedContext.delete(self.category!.todolist[indexPath.row])
                    
                    do {
                        try managedContext.save()
                        self.getData()
                    } catch let error as NSError {
                        fatalError("Error:\(error)")
                    }
                    completion(true)
                }
                alert.addAction(cancleAction)
                alert.addAction(deletetAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        deleteAction.backgroundColor = .init(red: 121/235, green: 121/235, blue: 130/235, alpha: 1)
        editAction.backgroundColor = UIColor(red: 232, green: 116, blue: 118)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        
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
