//
//  TermForUserKeyTuple.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper


class TermForUserKeyTuple : KeyTextTuple{
    
    var curInstanceExtraData : InstanceExtraData!
    
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        curInstanceExtraData    <- map["curInstanceExtraData"]
    }
}
