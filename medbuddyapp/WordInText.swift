//
//  WordInText.swift
//  medbuddyapp
//
//  Created by Admin User on 4/17/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class WordInText : Mappable{
   var text: String!
   var minTermSize: Int!
   var positionInTextByWords: Int!
   var positionInTextByChars: Int!
   var metaValue: String!
   var altMetaValue: String!
    
    init(text: String!, minTermSize: Int!, positionInTextByWords: Int, positionInTextByChars: Int,metaValue: String!,
        altMetaValue: String!) {
        self.text = text
        self.positionInTextByWords = positionInTextByWords
        self.positionInTextByChars = positionInTextByChars
        self.metaValue = metaValue
        self.altMetaValue = altMetaValue
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        text                    <- map["text"]
        minTermSize             <- map["minTermSize"]
        positionInTextByWords   <- map["positionInTextByWords"]
        positionInTextByChars   <- map["positionInTextByChars"]
        metaValue               <- map["metaValue"]
        altMetaValue            <- map["altMetaValue"]
    }
}
