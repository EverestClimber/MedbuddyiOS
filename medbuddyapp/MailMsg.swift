//
//  MailMsg.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class MailMsg : Mappable{
    var replyForPatientsLikeMe : Bool!
    var fromUserName : String!
    var toUserName : String!
    var msgTitle : String!
    var msgText : String!
    var language : String!
    var read : Bool!
    var visitId : String!
    var fileId : String!
    var relatedMsgId : String!
    var sentdate : Int!
    var forPatientsLikeMe : Bool!
    var termListIds : [String]!
    var recpientDeltedIt : Bool!
    var idAsStr : String!


    
    init(replyForPatientsLikeMe : Bool!,
        fromUserName : String!,
        toUserName : String!,
        msgTitle : String!,
        msgText : String!,
        language : String!,
        read : Bool!,
        visitId : String!,
        fileId : String!,
        relatedMsgId : String!,
        sentdate : Int!,
        forPatientsLikeMe : Bool!,
        termListIds : [String]!,
        recpientDeltedIt : Bool!,
        idAsStr : String!) {
        self.replyForPatientsLikeMe = replyForPatientsLikeMe
        self.fromUserName = fromUserName
        self.toUserName = toUserName
        self.msgTitle = msgTitle
        self.msgText = msgText
        self.language = language
        self.read = read
        self.visitId = visitId
        self.fileId = fileId
        self.relatedMsgId = relatedMsgId
        self.sentdate = sentdate
        self.forPatientsLikeMe = forPatientsLikeMe
        self.termListIds = termListIds
        self.recpientDeltedIt = recpientDeltedIt
        self.idAsStr = idAsStr
    }
    
    required init(map : Map) {
        
    }
    
    func mapping(map : Map){
        replyForPatientsLikeMe      <-  map["replyForPatientsLikeMe"]
        fromUserName                <-  map["fromUserName"]
        toUserName                  <-  map["toUserName"]
        msgTitle                    <-  map["msgTitle"]
        msgText                     <-  map["msgText"]
        language                    <-  map["language"]
        read                        <-  map["read"]
        visitId                     <-  map["visitId"]
        fileId                      <-  map["fileId"]
        relatedMsgId                <-  map["relatedMsgId"]
        sentdate                    <-  map["sentdate"]
        forPatientsLikeMe           <-  map["forPatientsLikeMe"]
        termListIds                 <-  map["termListIds"]
        recpientDeltedIt            <-  map["recpientDeltedIt"]
        idAsStr                     <-  map["idAsStr"]
    }
    
}
