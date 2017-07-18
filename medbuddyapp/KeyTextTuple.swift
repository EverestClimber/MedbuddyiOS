//
//  KeyTextTuple.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class KeyTextTuple : Mappable{
    
    
    var key: String!
    var name: String!
    var extraText: String!
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        key                <- map["key"]
        name               <- map["name"]
        extraText          <- map["extraText"]
    }
}
