//
//  Alert.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 public enum EAlertSeverity {
	CRITICAL,
	WARNING,
	INFO
 }
 public enum EFeedBack {
 NONE,
 THUMB_UP,
 THUMB_DOWN
 }

*/
class Alert : Mappable{
    var userId: String!
    var visitID: String!
    var alertType: String!
    var msg: String!
    var severity: String!
    var reminderDetails: ReminderDetails!
    var active: Bool!
    var feedBack: String!
    var creationDate: Int!
    var idAsStr : String!
     
    init(userId: String!,
        visitID: String!,
        alertType: String!,
        msg: String!,
        severity: String!,
        reminderDetails: ReminderDetails!,
        active: Bool!,
        feedBack: String!,
        creationDate: Int!,
        idAsStr : String!) {
        
        self.userId = userId;
        self.visitID = visitID;
        self.alertType = alertType;
        self.msg = msg;
        self.severity = severity;
        self.reminderDetails = reminderDetails
        self.active = active;
        self.feedBack = feedBack
        self.creationDate = creationDate
        self.idAsStr = idAsStr
    }
    required init(map : Map) {
   
    }
    func mapping(map: Map) {
        userId          <- map["userId"]
        visitID         <- map["visitID"]
        alertType       <- map["alertType"]
        msg             <- map["msg"]
        severity        <- map["severity"]
        reminderDetails <- map["reminderDetails"]
        active          <- map["active"]
        feedBack        <- map["feedBack"]
        creationDate    <- map["creationDate"]
        idAsStr         <- map["idAsStr"]
    }
}
