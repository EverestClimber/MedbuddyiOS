//
//  InstanceExtraDataRelation.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
class InstanceExtraDataRelation {
    private var instanceExtradata: InstanceExtraData!
    private var termInstance: TermInstance!
    private var distanceBetweenInstanceAndExtraData: Int!
    
    public init(_ instanceExtradata: InstanceExtraData!, _ termInstance: TermInstance!, _ distanceBetweenInstanceAndExtraData: Int!) {
        super.init()
        self.instanceExtradata = instanceExtradata
        self.termInstance = termInstance
        self.distanceBetweenInstanceAndExtraData = distanceBetweenInstanceAndExtraData
    }
    
    public func getInstanceExtradata() -> InstanceExtraData! {
        return instanceExtradata
    }
    
    public func setInstanceExtradata(_ instanceExtradata: InstanceExtraData!) {
        self.instanceExtradata = instanceExtradata
    }
    
    public func getTermInstance() -> TermInstance! {
        return termInstance
    }
    
    public func setTermInstance(_ termInstance: TermInstance!) {
        self.termInstance = termInstance
    }
    
    public func getDistanceBetweenInstanceAndExtraData() -> Int! {
        return distanceBetweenInstanceAndExtraData
    }
    
    public func setDistanceBetweenInstanceAndExtraData(_ distanceBetweenInstanceAndExtraData: Int!) {
        self.distanceBetweenInstanceAndExtraData = distanceBetweenInstanceAndExtraData
    }
    
    public func getExtraDataStartPosition() -> Integer! {
        if instanceExtradata != nil {
            return instanceExtradata.getStartPositionInWords()
        }
        return 0
    }
}
