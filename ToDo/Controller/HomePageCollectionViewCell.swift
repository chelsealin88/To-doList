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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deletebutton(_ sender: Any) {
        
    }
    
}
