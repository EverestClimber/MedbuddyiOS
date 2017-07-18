//
//  UserStatus.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class UserStatus : Mappable{
    var totalNumOfAlerts : Int!
    var totalNumOfReminders : Int!
    var totalNumOfMails : Int!
    var numOfActiveAlerts : Int!
    var numOfExpiredReminders : Int!
    var numOfUnreadMails : Int!
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        totalNumOfAlerts        <- map["totalNumOfAlerts"]
        totalNumOfReminders     <- map["totalNumOfReminders"]
        totalNumOfMails         <- map["totalNumOfMails"]
        numOfActiveAlerts       <- map["numOfActiveAlerts"]
        numOfExpiredReminders   <- map["numOfExpiredReminders"]
        numOfUnreadMails        <- map["numOfUnreadMails"]
    }
    func isEqual(status : UserStatus) -> Bool{
        if (totalNumOfAlerts == status.totalNumOfAlerts && totalNumOfReminders == status.totalNumOfReminders && totalNumOfMails == status.totalNumOfMails && numOfActiveAlerts == status.numOfActiveAlerts && numOfExpiredReminders == status.numOfExpiredReminders && numOfUnreadMails == status.numOfUnreadMails){
            return true
        }
        return false
    }
}
