//
//  Location.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
class Location : Mappable {
    var placeName: String! = ""
    var country: String!
    var state: String!
    var city: String!
    var street: String! = ""
    var numberInStreet: String! = ""
    var idAsStr : String! = ""

    
    init(placeName: String!, country: String!, state: String!, city: String!, street: String!, numberInStreet: String!) {
        self.placeName = placeName
        self.country = country
        self.state = state
        self.city = city
        self.street = street
        self.numberInStreet = numberInStreet
        self.idAsStr = ""
    }
    required init?(map: Map) {
    

    }
    
    
    func mapping(map: Map) {
        placeName         <- map["placeName"]
        if (placeName == nil){
            placeName = ""
        }
        country           <- map["country"]
        state             <- map["state"]
        city              <- map["city"]
        street            <- map["street"]
        if (street == nil){
            street = ""
        }
        numberInStreet    <- map["numberInStreet"]
        if (numberInStreet == nil){
            numberInStreet = ""
        }
        idAsStr           <- map["idAsStr"]
        if (idAsStr == nil)
        {
            idAsStr = ""
        }
    }
}
