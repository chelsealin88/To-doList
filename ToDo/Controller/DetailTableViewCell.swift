//
//  DetailTableViewCell.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/5/8.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    

    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var detailTextview: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
