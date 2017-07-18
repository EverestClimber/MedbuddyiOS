//
//  RecognitionTask.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
class RecognitionTask : AppEntity {
    
    var visitId : String!
    var fileId : String!
    var userId : String!
    var creationDate : Date!
    var startProcessDate : Date!
    var workerId : String!
    var fileStatus : EFileStatus!
    var lastErr : String!
    var recType : ERecogntitionType!
    
    override init() {
        
    }
    init( visitId : String, fileId : String, userId : String,
          p_recType : ERecogntitionType) {
        super.init()
        self.visitId = visitId;
        self.fileId = fileId;
        self.userId = userId;
        self.recType = p_recType;
        self.creationDate = Date();
        self.fileStatus = EFileStatus.NOT_PROCESSED;
    }
    public func getVisitId() -> String! {
        return visitId
    }
    
    public func setVisitId(_ visitId: String!) {
        self.visitId = visitId
    }
    
    public func getFileId() -> String! {
        return fileId
    }
    
    public func setFileId(_ fileId: String!) {
        self.fileId = fileId
    }
    
    public func getUserId() -> String! {
        return userId
    }
    
    public func setUserId(_ userId: String!) {
        self.userId = userId
    }
    
    public func getCreationDate() -> Date! {
        return creationDate
    }
    
    public func setCreationDate(_ creationDate: Date!) {
        self.creationDate = creationDate
    }
    
    public func getStartProcessDate() -> Date! {
        return startProcessDate
    }
    
    public func setStartProcessDate(_ startProcessDate: Date!) {
        self.startProcessDate = startProcessDate
    }
    
    public func getWorkerId() -> String! {
        return workerId
    }
    
    public func setWorkerId(_ workerId: String!) {
        self.workerId = workerId
    }
    
    public func getFileStatus() -> EFileStatus! {
        return fileStatus
    }
    
    public func setFileStatus(_ fileStatus: EFileStatus!) {
        self.fileStatus = fileStatus
    }
    
    public func getLastErr() -> String! {
        return lastErr
    }
    
    public func setLastErr(_ lastErr: String!) {
        self.lastErr = lastErr
    }
    
    public func getRecType() -> ERecogntitionType! {
        return recType
    }
    
    public func setRecType(_ recType: ERecogntitionType!) {
        self.recType = recType
    }    
}
