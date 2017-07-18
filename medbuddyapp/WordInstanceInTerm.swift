//
//  WordInstanceInTerm.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class WordInstanceInTerm : Mappable{
    var wordInTerm: WordInText!
    
    // // Original word in the original term
    var wordInText: WordInText!
    
    // // The real word that was found in text
    var similarity: Double!
    
    // // 0-1: 1 is identical , 0 none , between it mean that there is a soundex //similarity
    var startPositionByChars: Int!
    
    // // Start position in the content (in characters)
    var startPositionInWords: Int!
    
    // // Start position in the content (in words)
    var positionInTerm: Int!
    
    
    init(wordInTerm: WordInText!,
        wordInText: WordInText!,
        similarity : Double!,
        startPositionByChars: Int!,
        startPositionInWords: Int!,
        positionInTerm: Int!) {
        self.wordInTerm = wordInTerm
        self.wordInText = wordInText
        self.similarity = similarity
        self.startPositionInWords = startPositionInWords
        self.startPositionByChars = startPositionByChars
        self.positionInTerm = positionInTerm
    }
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        wordInTerm              <- map["wordInTerm"]
        wordInText              <- map["wordInText"]
        similarity              <- map["similarity"]
        startPositionInWords    <- map["startPositionInWords"]
        startPositionByChars    <- map["startPositionByChars"]
        positionInTerm          <- map["positionInTerm"]
    }
}
