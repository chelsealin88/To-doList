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
    
    
    var coredata = CoreData()
    var indexNumber = 0
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
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coredata.getCategoryData {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
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
            let createcell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateCell", for: indexPath) as! HomePageCollectionViewCell
            
            createcell.backgroundColor = .gray
            createcell.layer.cornerRadius = 10 
            return createcell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! HomePageCollectionViewCell
        
        let type = categories[indexPath.row]
        cell.categoryName.text = type.name
        cell.layer.cornerRadius = 10
        

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == categories.count {
       
            alertWithTextField()
            
        } else {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodoViewController") as! TodoViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
    
    }
    
    // MARK: UICollectionViewDelegate
    
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    func registerNib(nibname: String) {
        let nib = UINib(nibName: nibname, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: nibname)
    }
    
    //Save Data
    func save(categoryName: String) {
        coredata.saveCategory(category: categoryName)
    }
    
    func alertWithTextField() {
        let alert = UIAlertController(title: "Create a new category", message: "", preferredStyle: .alert)
        let save = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            guard let categoryName = textField.text else { return }
            if categoryName != "" {
                //todo : save data
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
        return UIEdgeInsets(top: 40, left: 10, bottom: 30, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 30) / 2
        
        return CGSize(width: width, height: width)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
