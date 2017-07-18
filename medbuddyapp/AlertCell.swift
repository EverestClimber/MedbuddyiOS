//
//  AlertCell.swift
//  medbuddyapp
//
//  Created by Admin User on 4/5/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import SwipeCellKit
class AlertCell: SwipeTableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var creationDate: UILabel!
    
    @IBOutlet weak var alertIcon: UIImageView!
    
    @IBOutlet weak var feedbackBtn: UIButton!
    
    @IBOutlet weak var msgText: UILabel!
    
    @IBOutlet weak var bellIcon: UIImageView!
    
    var feedbackState : Int = 0//0 : NONE,1 : UP,2 : DOWN
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onfeedbackbutton(_ sender: Any) {
        feedbackState = (feedbackState + 1) % 3
        switch feedbackState {
        case 0:
            feedbackBtn.setImage(UIImage(named : "thumb-none"), for : .normal)
        case 1:
            feedbackBtn.setImage(UIImage(named : "thumb-up"), for: .normal)
        case 2:
            feedbackBtn.setImage(UIImage(named : "thumb-down"), for: .normal)
        default:
            break
        }

    }
}
