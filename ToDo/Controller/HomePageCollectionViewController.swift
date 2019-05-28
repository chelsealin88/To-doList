//
//  HomePageCollectionViewController.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/4/23.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class HomePageCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var tasknumber = Int()
    var coredata = CoreData()
    var category: Category?
    var categories : [Category] {
        return coredata.categoryList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib(nibname: "CategoryCell")
        registerNib(nibname: "CreateCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coredata.getCategoryData {
            self.collectionView.reloadData()
        }
    }
    
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.post(name: .didEditCategory, object: nil)
        
        guard let title = sender.title else { return }
        switch title {
        case "Edit":
            // edit 觸發時開始觀察
            sender.title = "Save"
            NotificationCenter.default.addObserver(self, selector: #selector(doDelete), name: .deleteCategory, object: nil)
        case "Save":
            // edit -> complete 結束觀察
            sender.title = "Edit"
        default:
            fatalError()
        }
    }
    
    // Delete Category
    @objc func doDelete(_ notification: Notification) {
        guard let index = notification.userInfo?["tag"] as? Int else { return }
        let aCategory = categories[index]
        
        let alert = UIAlertController(title: "Are you sure to delete?", message: "", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        let deletetAction = UIAlertAction(title: "Delete", style: .default) { (alert) in
            
            let managedContext = self.coredata.appDelegate.persistentContainer.viewContext
            self.coredata.managedContext.delete(aCategory)
            
            do {
                try managedContext.save()
                self.coredata.getCategoryData {
                    self.collectionView.reloadData()
                }
            } catch let error as NSError {
                fatalError("\(error)")
            }
        }
        alert.addAction(cancleAction)
        alert.addAction(deletetAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    //    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == categories.count {
            let createcell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateCell", for: indexPath) as! CreateCategoryCollectionViewCell
            createcell.view.layer.cornerRadius = 10
            
            return createcell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! HomePageCollectionViewCell
        let aCategory = categories[indexPath.row]
        cell.categoryName.text = aCategory.name
        
        guard let todos = aCategory.todos?.allObjects.filter({ (todo) -> Bool in
            return !(todo as! ToDo).done
        }).count else { return  cell }
        tasknumber = todos
        cell.tasksNumber.text = "\(tasknumber) tasks"
        cell.view.layer.cornerRadius = 10
        cell.notificationAddObserver()
        cell.tag = indexPath.item
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == categories.count {
            
            alertWithTextField()
            
        } else {
            var navigationtitle = String()
            let aCategory = categories[indexPath.row]
            navigationtitle = aCategory.name!
        
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodoViewController") as! TodoViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationTitle = navigationtitle
            vc.category = aCategory
            
        }
        
    }

    
    func registerNib(nibname: String) {
        let nib = UINib(nibName: nibname, bundle: .main)
        self.collectionView.register(nib, forCellWithReuseIdentifier: nibname)
    }
    
    //Save Data
    func save(categoryName: String) {
        coredata.saveCategory(category: categoryName)
    }
    
    //Add category text field
    func alertWithTextField() {
        
        let alert = UIAlertController(title: "Create a new category", message: "", preferredStyle: .alert)
        let save = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            guard let categoryName = textField.text else { return }
            if categoryName != "" {
                //save data
                self.save(categoryName: categoryName)
                self.collectionView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addTextField { (textField) in
            textField.placeholder = "Category name"
        }
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension HomePageCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 0, bottom: 30, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 20) / 2
        
        return CGSize(width: width, height: width)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension Notification.Name {
    
    static let didEditCategory = Notification.Name("didEditCategory")
    static let deleteCategory = Notification.Name("deleteCategory")
    
}
