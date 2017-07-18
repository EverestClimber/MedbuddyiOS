//
//  ReminderDetails.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation

import ObjectMapper

class ReminderDetails : Mappable{
    
    
    public init(recurring: Bool!,
        dueDate: Int!,
        recurringType: String!,
        nextAlerttime: Int!,
        alertId: String!,
        active: Bool!,
        hoursInDayToRemind: [Int]!,
        daysInWeekToRemind: [Int]!,
        daysInMonthToRemind:[Int]!) {
        
        self.recurring = recurring
        self.dueDate = dueDate
        self.recurringType = recurringType
        self.nextAlerttime = nextAlerttime
        self.alertId = alertId
        self.active = active
        self.hoursInDayToRemind = hoursInDayToRemind
        self.daysInWeekToRemind = daysInWeekToRemind
        self.daysInMonthToRemind = daysInMonthToRemind
    }
    public init(){
        
    }
    /*    private boolean isRecurring;
     
     private Date dueDate;
     
     private ERecurringType recurringType;
     
     private Date nextAlerttime;
     
     private String alertId;
     
     private boolean isActive;
     
     private List<Integer> hoursInDayToRemind;
     private List<Integer> daysInWeekToRemind;
     private List<Integer> daysInMonthToRemind;*/
    var recurring: Bool!
    var dueDate: Int!
    var recurringType: String!
    var nextAlerttime: Int!
    var alertId: String!
    var active: Bool!
    var hoursInDayToRemind: [Int]!
    var daysInWeekToRemind: [Int]!
    var daysInMonthToRemind:[Int]!
    
    required init(map : Map) {
    }
    func mapping(map: Map) {
        recurring                   <- map["recurring"]
        dueDate                     <- map["dueDate"]
        recurringType               <- map["recurringType"]
        nextAlerttime               <- map["nextAlerttime"]
        alertId                     <- map["alertId"]
        active                      <- map["active"]
        hoursInDayToRemind          <- map["hoursInDayToRemind"]
        daysInWeekToRemind          <- map["daysInWeekToRemind"]
        daysInMonthToRemind         <- map["daysInMonthToRemind"]
        
        
    }
}
