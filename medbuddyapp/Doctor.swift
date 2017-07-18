//
//  Doctor.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper

class Doctor : Mappable {
    var name: String!
    var email: String!
    var drCategory: String!
    var drLocation: Location!
    var namesList: [String]!
    var idAsStr : String!
    init(name : String!, email : String!, drCategory : String!, drLocation : Location!, namesList : [String]!, idAsStr : String!) {
        self.name = name
        self.email = email
        self.drCategory = drCategory
        self.drLocation = drLocation
        self.namesList = namesList
        self.idAsStr = idAsStr
    }
    required init(map : Map) {
    }
    func mapping(map: Map) {
        name            <- map["name"]
        email           <- map["email"]
        drCategory      <- map["drCategory"]
        drLocation      <- map["drLocation"]
        namesList       <- map["nameList"]
        idAsStr         <- map["idAsStr"]
    }
}
