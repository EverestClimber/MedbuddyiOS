//
//  MedFile.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class MedFile : Mappable{
    var uploadedFileLocation: String!
    var userName: String!
    var title: String!
    var visitId: String!
    var allowedUserNames: [String]!
    var _isForOCR: Bool!
    var fileType: String!
    var fileSize: Int!
    var forSpeech: Bool!
    var deleted : Bool!
    var idAsStr : String!
    
    
    required init(map : Map) {
        
    }
    
    func mapping(map : Map){
        uploadedFileLocation    <- map["uploadedFileLocation"]
        userName                <- map["userName"]
        title                   <- map["title"]
        visitId                 <- map["visitId"]
        allowedUserNames        <- map["allowedUserNames"]
        _isForOCR               <- map["_isForOCR"]
        fileType                <- map["fileType"]
        fileSize                <- map["fileSize"]
        forSpeech               <- map["forSpeech"]
        deleted                 <- map["deleted"]
        idAsStr                 <- map["idAsStr"]
    }

}
