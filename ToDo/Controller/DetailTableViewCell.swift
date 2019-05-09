//
//  DetailTableViewCell.swift
//  ToDo
//
//  Created by Chelsea Lin on 2019/5/8.
//  Copyright © 2019 chelsea lin. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    

    @IBOutlet weak var titleTextfield: UITextField?
    @IBOutlet weak var detailTextview: UITextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func iseditable() {
        
//        guard let textfield = titleTextfield else { print("😀"); return }
        
        titleTextfield?.isEnabled = true
        titleTextfield?.backgroundColor = UIColor(red: 235, green: 235, blue: 235)
        detailTextview?.isEditable = true
        detailTextview?.backgroundColor = UIColor(red: 235, green: 235, blue: 235)
        
        // 判斷有沒有text field？做事
        
    }
    
    func finishEdit() {
        
        titleTextfield?.isEnabled.toggle()
        titleTextfield?.backgroundColor = .clear
        detailTextview?.isEditable.toggle()
        detailTextview?.backgroundColor = .clear
        
    }

    
}
