//
//  TermInstance.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class TermInstance : Mappable {
    // // The relevant words that exists in the text
    var wordsInstanceList: [WordInstanceInTerm]!
    var maxWordIndexInText: Int!
    // //the maximum word index found in text
    var startPositionInWords: Int!
    // // Start position in the content (in words)
    // // The original term
    var term: Term!
    var instanceExtraData: InstanceExtraData!
    // // 0-1:  1 is identical , 0 none , between it mean that there is a similarity - some but the words are not identical
    var similarity: Double!
    required init?(map: Map) {
    }
    init(wordsInstanceList: [WordInstanceInTerm]!,
        maxWordIndexInText: Int!,
        startPositionInWords: Int!,
        term: Term!,
        instanceExtraData: InstanceExtraData!,
        similarity: Double!) {
        
        self.wordsInstanceList = wordsInstanceList
        self.maxWordIndexInText = maxWordIndexInText
        self.startPositionInWords = startPositionInWords
        self.term = term
        self.instanceExtraData = instanceExtraData
        self.similarity = similarity
        
    }
    
    func mapping(map: Map) {
        wordsInstanceList       <- map["wordsInstanceList"]
        maxWordIndexInText      <- map["maxWordIndexInText"]
        startPositionInWords    <- map["startPositionInWords"]
        term                    <- map["term"]
        instanceExtraData       <- map["instanceExtraData"]
        similarity              <- map["similarity"]
    }
}
