//
//  DetailTableViewController.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/5/7.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UITextViewDelegate{
    
    let center : NotificationCenter = NotificationCenter.default
    var todo : ToDo?
    var coredata = CoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
//        tableView.estimatedRowHeight = 60
//        tableView.rowHeight = UITableView.automaticDimension
       
        registerNib(nibname: "TitleCell")
        registerNib(nibname: "DetailCell")
        
        //Listion to Keyboard
        center.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
    }
    
    //Stop to listion keyboard
    deinit {
        center.removeObserver(self)
    }
    
    weak var listvc: TodoViewController?
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch (section) {
        case 0: return "Title"
        case 1: return "Detail"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    lazy var height : CGFloat! = view.frame.height / 5
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return height
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! DetailTableViewCell
            cell.titleTextfield?.text = todo?.title
            return cell
            
        } else {
            let detailcell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
            detailcell.detailTextview?.text = todo?.detail
            detailcell.detailTextview?.delegate = self
            self.textview = detailcell.detailTextview
            return detailcell
        }
        
        // Configure the cell...
        
    }
    
    var textview : UITextView?
    
    //Setting keyboard
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
         
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        height = 100
        tableView.scrollIndicatorInsets = tableView.contentInset
        DispatchQueue.main.async {
            self.tableView.setContentOffset(.init(x: 0, y:  -self.tableView.adjustedContentInset.top), animated: false)
        }
        
    }
    
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        
        guard let title = sender.title else { return }
        let textfieldCell = tableView.cellForRow(at: .init(row: 0, section: 0)) as! DetailTableViewCell
        let textviewCell = tableView.cellForRow(at: .init(row: 0, section: 1)) as! DetailTableViewCell
        switch title {
        case "Edit":
            sender.title = "Save"
            
            textfieldCell.iseditable()
            textviewCell.iseditable()
        case "Save":
            sender.title = "Edit"
            
            textfieldCell.finishEdit()
            textviewCell.finishEdit()
            
            let titleText = textfieldCell.titleTextfield?.text ?? ""
            let detailText = textviewCell.detailTextview?.text ?? ""
            
            save(title: titleText, detail: detailText)
            listvc?.tableView.reloadData()
        default:
            fatalError()
        }
    }
    
    func save(title: String, detail: String) {
        
        if let todo = todo {
            todo.title = title
            todo.detail = detail
            try! coredata.save()
            
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func registerNib(nibname: String) {
        let nib = UINib(nibName: nibname, bundle: .main)
        self.tableView.register(nib, forCellReuseIdentifier: nibname)
    }
    
}


