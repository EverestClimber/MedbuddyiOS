//
//  ConversationContent.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class ConversationContent : Mappable{
    var userId: String!
    // // User credential
    var visitId: String!
    var rawTranscript: String!
    // // Text of the partial call
    var termsInText: [TermInstance]!
    var last: Bool!
    // // True if the phone call is finished and this the last part
    var numberInSeq: Int!
    // // Sequential order
    var audioFile: [UInt8]!
    // // For future use
    var isFromOCR: Bool!
    var file_id: String!
    // // Link to MedFile entity
    var fileStatus: String!
    var idAsStr : String!
    var deleted : Bool!
    /*		"visitId": "588b799f65e02e3d40871b2b",
     "userId": "adimeiman-1421506366@gmail.com",
     "audioFile": null,
     "numberInSeq": 1,
     "termsInText": [],
     "rawTranscript": "Probably it is Pneumonia, with a risk to Crohn disease or Lichen Sclerosus I will subscribe you Augmentin 500 mg it is taken as tablets it is taken twice a day after meal If your condition will not improve in 3 days return to me as soon as possible.",
     "last": false,
     "file_id": "”59993hdhdjdjhd444dd",
     "idAsStr": null,
     "deleted": false*/
    init(visitId: String!, userId: String!, rawTranscript: String!, termsInText: [TermInstance]!, last: Bool!, numberInSeq: Int, audioFile : [UInt8]!, isFromOCR: Bool!, fileId : String!, fileStatus : String!, idAsStr : String!, deleted:Bool!) {
        self.visitId = visitId
        self.userId = userId
        self.rawTranscript = rawTranscript
        self.termsInText = termsInText
        self.last = last
        self.numberInSeq = numberInSeq
        self.fileStatus = fileStatus
        self.audioFile = audioFile
        self.isFromOCR = isFromOCR
        self.file_id = fileId
        self.idAsStr = idAsStr
        self.deleted = deleted
    }
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        visitId             <- map["visitId"]
        userId              <- map["userId"]
        rawTranscript       <- map["rawTranscript"]
        termsInText         <- map["termsInText"]
        last                <- map["last"]
        numberInSeq         <- map["numberInSeq"]
        fileStatus          <- map["fileStatus"]
        audioFile           <- map["audioFile"]
        isFromOCR           <- map["isFromOCR"]
        file_id             <- map["file_id"]
        idAsStr             <- map["idAsStr"]
        deleted             <- map["deleted"]
    }
    
    
}
