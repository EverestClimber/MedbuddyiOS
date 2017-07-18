//
//  MedicineExtraData.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class MedicineExtraData : TermExtraData{
    var type : String!
    
    var medicationClass: String!
    
    var prescribedFor: String!

    var relatedDiseasesList: [KeyTextTuple]!
    
    var relatedDiseases: String!
    
    var sideEffect: String!

    var sideEffectsList: [KeyTextTuple]!
    
    var storageDetails: String!

    var hasWarningForPrugnency: Bool!
    
    var prugnencyDetails: String!
    
    var hasWarningForNursingMothers: Bool!
    
    var nursingMothersDetails: String!
    
    var drugsInteractionsList: [KeyTextTuple]!
    
    var drugsInteractions: String!
    
    var dosing: String!
    
    var dosingList: [MedicationDosing]!
    
    var warningList: [String]!
    
    var diseasesWithWarnings: [KeyTextTuple]!
    
    var name: String!
    
    var idAsStr : String!
    
    var deleted : Bool!
    init(type : String!,
        medicationClass: String!,
        prescribedFor: String!,
        relatedDiseasesList: [KeyTextTuple]!,
        relatedDiseases: String!,
        sideEffect: String!,
        sideEffectsList: [KeyTextTuple]!,
        storageDetails: String!,
        hasWarningForPrugnency: Bool!,
        prugnencyDetails: String!,
        hasWarningForNursingMothers: Bool!,
        nursingMothersDetails: String!,
        drugsInteractionsList: [KeyTextTuple]!,
        drugsInteractions: String!,
        dosing: String!,
        dosingList: [MedicationDosing]!,
        warningList: [String]!,
        diseasesWithWarnings: [KeyTextTuple]!,
        name: String!,
        idAsStr : String!,
        deleted : Bool!)
    {
        
        super.init(termKey: "termKey")
        
        self.type = type
        self.medicationClass = medicationClass
        self.prescribedFor = prescribedFor
        self.relatedDiseases = relatedDiseases
        self.relatedDiseasesList = relatedDiseasesList
        self.sideEffect = sideEffect
        self.sideEffectsList = sideEffectsList
        self.storageDetails = storageDetails
        self.hasWarningForPrugnency = hasWarningForPrugnency
        self.hasWarningForNursingMothers = hasWarningForNursingMothers
        self.prugnencyDetails = prugnencyDetails
        self.nursingMothersDetails = nursingMothersDetails
        self.drugsInteractionsList = drugsInteractionsList
        self.drugsInteractions = drugsInteractions
        self.dosing = dosing
        self.dosingList = dosingList
        self.warningList = warningList
        self.diseasesWithWarnings = diseasesWithWarnings
        self.name = name
        self.idAsStr = idAsStr
        self.deleted = deleted
    }
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        type                                <- map["type"]
        medicationClass                     <- map["medicationClass"]
        prescribedFor                       <- map["prescribedFor"]
        relatedDiseasesList                 <- map["relatedDiseasesList"]
        relatedDiseases                     <- map["relatedDiseases"]
        sideEffect                          <- map["sideEffect"]
        sideEffectsList                     <- map["sideEffectsList"]
        storageDetails                      <- map["storageDetails"]
        hasWarningForPrugnency              <- map["hasWarningForPrugnency"]
        prugnencyDetails                    <- map["prugnencyDetails"]
        hasWarningForNursingMothers         <- map["hasWarningForNursingMothers"]
        nursingMothersDetails               <- map["nursingMothersDetails"]
        drugsInteractionsList               <- map["drugsInteractionsList"]
        drugsInteractions                   <- map["drugsInteractions"]
        dosing                              <- map["dosing"]
        dosingList                          <- map["dosingList"]
        warningList                         <- map["warningList"]
        diseasesWithWarnings                <- map["diseasesWithWarnings"]
        name                                <- map["name"]
        idAsStr                             <- map["idAsStr"]
        deleted                             <- map["deleted"]
    }
}
