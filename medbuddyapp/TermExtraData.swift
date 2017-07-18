//
//  TermExtraData.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation

import ObjectMapper

class TermExtraData: Mappable {
    var termKey : String!
    
    init(termKey : String) {
        self.termKey = termKey
    }
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        termKey  <- map["termKey"]
    }
}
