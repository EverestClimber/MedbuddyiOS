//
//  VisitItemCell.swift
//  medbuddyapp
//
//  Created by Admin User on 4/4/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit

class VisitItemCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var contenttext: UITextView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var alertimage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
