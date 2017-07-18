//
//  MessageTableViewCell.swift
//  medbuddyapp
//
//  Created by Admin User on 4/5/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import SwipeCellKit
class MessageTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var message_source: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var sendDate: UILabel!
    
    @IBOutlet weak var message_direction: UIImageView!
    
    @IBOutlet weak var message_content: UILabel!
    
    @IBOutlet weak var attach: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUnread(readstatus : Bool){
        if readstatus == false{
            
            message_content.font = UIFont.boldSystemFont(ofSize: 13)
            message_source.font = UIFont.boldSystemFont(ofSize: 15)
            userName.font = UIFont.boldSystemFont(ofSize: 15)
            sendDate.font = UIFont.boldSystemFont(ofSize: 15)
        }
        else{
            message_content.font = UIFont.systemFont(ofSize: 13)
            message_source.font = UIFont.systemFont(ofSize: 15)
            userName.font = UIFont.systemFont(ofSize: 15)
            sendDate.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    
}
