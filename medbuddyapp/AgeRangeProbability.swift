//
//  AgeRangeProbability.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
class AgeRangeProbability{
    var fromAge : Int = 0;
    var toAge : Int = 0;
    var probability : Double = 0.0;
    init() {
        fromAge = 0
        toAge = 0
        probability = 0.0
    }
    func getFromAge() -> Int{
        return fromAge
    }
    func getToAge() -> Int{
        return toAge
    }
    func getProbability() -> Double{
        return probability
    }
    func setFromAge(fromAge : Int){
        self.fromAge = fromAge
    }
    func setToAge(toAge : Int){
        self.toAge = toAge
    }
    func setProbability(probability : Double){
        self.probability = probability
    }
    init(fromAge : Int, toAge : Int, probability : Double){
        self.fromAge = fromAge
        self.toAge = toAge
        self.probability = probability
    }
    
}
