//
//  StopWord.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
class StopWord : AppEntity {
    var language: String!
    var word: String!
    
    public func getLanguage() -> String! {
        return language
    }
    
    public func setLanguage(_ language: String!) {
        self.language = language
    }
    
    public func getWord() -> String! {
        return word
    }
    
    public func setWord(_ word: String!) {
        self.word = word
    }
    
    public init(_ language: String!, _ word: String!) {
        super.init()
        self.language = language
        self.word = word
    }
    
    override init() {
        super.init()
    }
    
    init(_ p_id: String!) {
        super.init()
        setIdAsStr(p_id)
    }
}
