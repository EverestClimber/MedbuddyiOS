//
//  Term.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
public class Term : Mappable{

    var termExtraData: TermExtraData!
    var synopsis: String!
    var url: String!
    var language: String!
    var subCategory: String!
    var category: String!
    var keyWords: [keyWords]!
    var nameList: [String]!
    var specificDrTypes : [String]!
    var idAsStr: String!
    var deleted: Bool!
    var forSpecificGender: Bool!
    var gender: String!
    var forSpecificAge: Bool!
    var minAge: Int!
    var maxAge: Int!
    var forSpecificDr: Bool!
    var wordCount: Int!
    init(_ termExtraData: TermExtraData!, _ synopsis: String!, _ url: String!, _ language: String!, _ subCategory: String!, _ category: String!, _ keyWords: [keyWords]!, _ nameList: [String]!, _ specificDrTypes: [String]!, _ idAsStr: String!, _ deleted: Bool!, _ forSpecificGender: Bool!, _ gender: String!, _ forSpecificAge: Bool!, _ minAge: Int!, _ maxAge: Int!, _ forSpecificDr: Bool!, _ wordCount: Int!) {

        self.termExtraData = termExtraData
        self.synopsis = synopsis
        self.url = url
        self.language = language
        self.subCategory = subCategory
        self.category = category
        self.keyWords = keyWords
        self.nameList = nameList
        self.specificDrTypes = specificDrTypes
        self.idAsStr = idAsStr
        self.deleted = deleted
        self.forSpecificGender = forSpecificGender
        self.gender = gender
        self.forSpecificAge = forSpecificAge
        self.minAge = minAge
        self.maxAge = maxAge
        self.forSpecificDr = forSpecificDr
        self.wordCount = wordCount
    }
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        termExtraData       <- map["termExtraData"]
        synopsis            <- map["synopsis"]
        url                 <- map["url"]
        language            <- map["language"]
        subCategory         <- map["subCategory"]
        category            <- map["category"]
        keyWords            <- map["keyWords"]
        nameList            <- map["nameList"]
        specificDrTypes     <- map["specificDrTypes"]
        idAsStr             <- map["idAsStr"]
        deleted             <- map["deleted"]
        forSpecificGender   <- map["forSpecificGender"]
        gender              <- map["gender"]
        forSpecificAge      <- map["forSpecificAge"]
        minAge              <- map["minAge"]
        maxAge              <- map["maxAge"]
        forSpecificDr       <- map["forSpecificDr"]
        wordCount           <- map["wordCount"]
    }
}
