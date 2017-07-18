//
//  Doseing.swift
//  medbuddyapp
//
//  Created by Admin User on 4/13/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper

class Doseing : Mappable{
    
    /*
     "fromDoseInMiligram": 100,
     "toDoseInMiligram": 200,
     "fromTimesPerDay": 1,
     "toTimesPerDay": 3,
     "maxMgPerDay": 300,
     "details": "This is details",
     "ageRange": "ADULTS",
     "medicationType": "capsulas",
     "specificDiseases": null,
     "forLongTerm": false
     */
    
    var fromDoseInMiligram: Int!
    
    var toDoseInMiligram: Int!
    
    var fromTimesPerDay: Double!
    
    var toTimesPerDay: Double!
    
    var maxMgPerDay: Double!
    
    var details: String!
    
    var ageRange: String!
    
    var medicationType: String!
    
    var specificDiseases: [KeyTextTuple]!
    
    var forLongTerm: Bool = false
    init(fromDoseInMiligram : Int,toDoseInMiligram : Int,fromTimesPerDay : Double,toTimesPerDay : Double, maxMgPerDay : Double, details: String!,ageRange : String!, medicationType : String!,specificDiseases : [KeyTextTuple]!,forLongTerm : Bool) {
        self.fromDoseInMiligram = fromDoseInMiligram
        self.toDoseInMiligram = toDoseInMiligram
        self.fromTimesPerDay = fromTimesPerDay
        self.toTimesPerDay = toTimesPerDay
        self.maxMgPerDay = maxMgPerDay
        self.details = details
        self.ageRange = ageRange
        self.medicationType = medicationType
        self.specificDiseases = specificDiseases
        self.forLongTerm = forLongTerm
    }
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        fromDoseInMiligram  <- map["fromDoseInMiligram"]
        toDoseInMiligram    <- map["toDoseInMiligram"]
        fromTimesPerDay     <- map["fromTimesPerDay"]
        toTimesPerDay       <- map["toTimesPerDay"]
        maxMgPerDay         <- map["maxMgPerDay"]
        details             <- map["details"]
        ageRange            <- map["ageRange"]
        medicationType      <- map["medicationType"]
        specificDiseases    <- map["specificDiseases"]
        forLongTerm         <- map["forLongTerm"]
    }
}
