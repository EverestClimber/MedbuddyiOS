//
//  InstanceExtraData.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class InstanceExtraData : Mappable{

    var type : String!
    var fromDate: Int64!
    var toDate: Int64!
    var startPositionInWords: Int!
    var maxWordIndexInText: Int!
    var result : String!
    var doseing : Doseing!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type                    <- map["type"]
        fromDate                <- map["fromDate"]
        toDate                  <- map["toDate"]
        startPositionInWords    <- map["startPositionInWords"]
        maxWordIndexInText      <- map["maxWordIndexInText"]
        result                  <- map["result"]
        doseing                 <- map["doseing"]
    }
    
    
    
}
