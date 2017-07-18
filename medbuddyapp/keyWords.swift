//
//  keyWords.swift
//  medbuddyapp
//
//  Created by Admin User on 4/17/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class keyWords: Mappable{
    var text: String!
    
    var minTermSize: Int!
    
    var positionInTextByWords: Int!
    
    var positionInTextByChars: Int!
    
    var idAsStr: String!
    
    var deleted: Bool!
    
    var metaValue: String!
    
    var altMetaValue: String!
    
    init(text: String!,
        minTermSize: Int!,
        positionInTextByWords: Int!,
        positionInTextByChars: Int!,
        idAsStr: String!,
        deleted: Bool!,
        metaValue: String!,
        altMetaValue: String!){
        self.text = text
        self.minTermSize = minTermSize
        self.positionInTextByWords = positionInTextByWords
        self.positionInTextByChars = positionInTextByChars
        self.idAsStr = idAsStr
        self.deleted = deleted
        self.metaValue = metaValue
        self.altMetaValue = altMetaValue
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        text                    <- map["text"]
        minTermSize             <- map["minTermSize"]
        positionInTextByWords   <- map["positionInTextByWords"]
        positionInTextByChars   <- map["positionInTextByChars"]
        idAsStr                 <- map["idAsStr"]
        deleted                 <- map["deleted"]
        metaValue               <- map["metaValue"]
        altMetaValue            <- map["altMetaValue"]
    }
}
