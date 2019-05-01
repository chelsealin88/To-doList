//
//  HomePageCollectionViewCell.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/4/23.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import UIKit

class HomePageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tasksNumber: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var deletebutton: UIButton!
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    
    func notificationAddObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(buttonisClick),
            name: .didEditCategory,
            object: nil)
    }
    
    @objc func buttonisClick() {
        
        deletebutton.isHidden.toggle()
    }
    
    

    @IBAction func deletebutton(_ sender: Any) {
        
        NotificationCenter.default.post(name: .deleteCategory, object: nil, userInfo: ["tag": tag])
        
    }
    
}
