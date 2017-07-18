//
//  DiseaseExtraData.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation

import ObjectMapper
class DiseaseExtraData : TermExtraData {
    
    var facts: String!
    var whatIsIt: String!
    var symptoms: String!
    var typeList: [String]!
    var symptomsList: [KeyTextTuple]!
    var howToDiagnose: String!
    var diagnoseTestList: [KeyTextTuple]!
    var relevantDrTypes: [String]!
    var treatments: String!
    var relatedMedicines: [KeyTextTuple]!
    var ageRangeList: [String]!
    public init(_ facts: String!, _ whatIsIt: String!, _ symptoms: String!, _ typeList: [String]!, _ symptomsList: [KeyTextTuple]!, _ howToDiagnose: String!, _ diagnoseTestList: [KeyTextTuple]!, _ relevantDrTypes: [String]!, _ treatments: String!, _ relatedMedicines: [KeyTextTuple]!, _ ageRangeList: [String]!) {
        super.init(termKey: "termKey")
        
        self.facts = facts
        self.whatIsIt = whatIsIt
        self.symptoms = symptoms
        self.typeList = typeList
        self.symptomsList = symptomsList
        self.howToDiagnose = howToDiagnose
        self.diagnoseTestList = diagnoseTestList
        self.relevantDrTypes = relevantDrTypes
        self.treatments = treatments
        self.relatedMedicines = relatedMedicines
        self.ageRangeList = ageRangeList

    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        facts           <- map["facts"]
        whatIsIt        <- map["whatIsIt"]
        symptoms        <- map["symptoms"]
        typeList        <- map["typeList"]
        symptomsList    <- map["symptomsList"]
        howToDiagnose   <- map["howToDiagnose"]
        diagnoseTestList <- map["diagnoseTestList"]
        relevantDrTypes <- map["relevantDrTypes"]
        treatments      <- map["treatments"]
        relatedMedicines <- map["relatedMedicines"]
        ageRangeList    <- map["ageRangeList"]
    }
}
