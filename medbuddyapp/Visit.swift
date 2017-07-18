//
//  Visit.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class Visit : Mappable{
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        contentList             <- map["contentList"]
        alerts                  <- map["alerts"]
        userName                <- map["userName"]
        startDate               <- map["startDate"]
        preVisitPointsList      <- map["preVisitPointsList"]
        visitStatus             <- map["visitStatus"]
        drType                  <- map["drType"]
        drKey                   <- map["drKey"]
        drEmail                 <- map["drEmail"]
        drName                  <- map["drName"]
        drPic                   <- map["drPic"]
        title                   <- map["title"]
        bodyArea                <- map["bodyArea"]
        language                <- map["language"]
        location                <- map["location"]
        allowedUserNames        <- map["allowedUserNames"]
        alertCount              <- map["alertCount"]
        
        idAsStr                 <- map["idAsStr"]
    }
    var contentList: [ConversationContent]!
    var alerts: [Alert]!
    var userName: String!
    var startDate: Int!
    var preVisitPointsList: [PointForVisit]!
    var visitStatus: String!
    var drType: String!
    var drKey: String?
    var drEmail: String!
    var drName: String!
    var drPic: String?
    var title: String!
    var bodyArea: String!
    var language: String!
    var location: Location!
    var allowedUserNames: [String]!
    var alertCount: Int!
    var idAsStr : String?
    var deleted : Bool!
    init(contentList : [ConversationContent]!,
         alerts : [Alert]!,
        userName: String!,
        startDate: Int!,
        preVisitPointsList: [PointForVisit]!,
        visitStatus: String!,
        drType: String!,
        drKey: String?,
        drEmail: String!,
        drName: String!,
        drPic: String?,
        title: String!,
        bodyArea: String!,
        language: String!,
        location: Location!,
        allowedUserNames: [String]!,
        alertCount: Int!,
        idAsStr : String?) {
        self.contentList = contentList
        self.alerts = alerts
        self.userName = userName
        self.startDate = startDate
        self.preVisitPointsList = preVisitPointsList
        self.visitStatus = visitStatus
        self.drType = drType
        self.drKey = drKey
        self.drEmail = drEmail
        self.drName = drName
        self.drPic = drPic
        self.title = title
        self.bodyArea = bodyArea
        self.language = language
        self.location = location
        self.allowedUserNames = allowedUserNames
        self.alertCount = alertCount
        self.idAsStr = idAsStr
    }
    
    
}
