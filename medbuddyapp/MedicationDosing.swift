//
//  MedicationDosing.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class MedicationDosing : Mappable{
    private var fromDoseInMiligram: Int!
    
    private var toDoseInMiligram: Int!
    
    private var fromTimesPerDay: Double!
    
    private var toTimesPerDay: Double!
    
    private var maxMgPerDay: Double!
    
    private var details: String!

    private var ageRange: String!
    
    private var medicationType: String!
    
    private var specificDiseases: [KeyTextTuple]!
    
    private var forLongTerm: Bool = false
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
    required init?(map: Map) {    }
    
    
    func mapping(map: Map) {
        fromDoseInMiligram      <- map["fromDoseInMiligram"]
        toDoseInMiligram        <- map["toDoseInMiligram"]
        fromTimesPerDay         <- map["fromTimesPerDay"]
        toTimesPerDay           <- map["toTimesPerDay"]
        maxMgPerDay             <- map["maxMgPerDay"]
        details                 <- map["details"]
        ageRange                <- map["ageRange"]
        medicationType          <- map["medicationType"]
        specificDiseases        <- map["specificDiseases"]
    }
}
