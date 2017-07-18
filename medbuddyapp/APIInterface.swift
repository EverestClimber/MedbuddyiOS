//
//  APIInterface.swift
//  medbuddyapp
//
//  Created by Emperor on 11/04/2017.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
class APIInterface{
    static let AuthenticationURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/authentication"
    static let LocationURL = "http://www.geonames.org/childrenJSON"
    static let UserManagementURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/user"
    static let TermURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/term"
    static let VisitURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/visit"
    static let DoctorURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/doctors/dr"
    static let DoctorListURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/doctors/drlist"
    static let DoctorCreateURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/doctors"
    
    static let FileURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/files/files"
    
    static let ConversationURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/conversationcontent"
    
    static let AlertURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/alert"
    
    static let MsgURL = "http://104.197.200.182:8080/medbuddyservernew-1.0.0/rest/msg"
}
