//
//  PointForVisit.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class PointForVisit : Mappable{
    
    var pointText : String!
    var pointCategory : String!/*public enum EPointCategory {
     SYMPTOMS, // I am suffering from these symptoms for X days
     SYMPTOM_DETAILS,	//         The pain is stronger especially at night
     MEDICINES,	//         I am taking this medicine
     PREVIOUS_VISITS,	//         I went to Dr before and he subscribed me X and it helped/ didnt helped
     PREVIOUS_INSPECTIONS,	//         I started tests and the results were ...
     UNKNOWN
     }
     */
    var forSpecificDr : Bool!
    var templatePoint : Bool!
    
    var defaultPointKey : String!
    
    var relevantDrTypes : [String]!
    var idAsStr : String!
    var deleted : Bool!
    
    
    init(pointText : String!,
        pointCategory : String!,
        forSpecificDr : Bool!,
        templatePoint : Bool!,
        defaultPointKey : String!,
        relevantDrTypes : [String]!,
        idAsStr : String!,
        deleted : Bool!) {
        
        self.pointText = pointText
        self.pointCategory = pointCategory
        self.forSpecificDr = forSpecificDr
        self.templatePoint = templatePoint
        self.defaultPointKey = defaultPointKey
        self.relevantDrTypes = relevantDrTypes
        self.idAsStr = idAsStr
        self.deleted = deleted
    }
    
    required init(map : Map) {
    }
    
    func mapping(map: Map) {
        pointText           <- map["pointText"]
        pointCategory       <- map["pointCategory"]
        forSpecificDr       <- map["forSpecificDr"]
        templatePoint       <- map["templatePoint"]
        defaultPointKey     <- map["defaultPointKey"]
        relevantDrTypes     <- map["relevantDrTypes"]
        idAsStr             <- map["idAsStr"]
        deleted             <- map["deleted"]
    }
}
