//
//  Resource.swift
//  medbuddyapp
//
//  Created by Emperor on 11/04/2017.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
class Resource{
    static let Login_OK = "Login Success"
    static let Login_406 = "User must change password"
    static let Login_401 = "Wrong Password or Email"
    static let Login_ForgotLink = "Mail will be sent to you with a temporary password"
    
    static let ReplacePassword_Val1 = "Password must be 6-20 characters"
    static let ReplacePassword_Val2 = "Password must be 6-20 characters , must contains uppercase and/or lowercase , can contain special characters (!@#$% ) and must contain numbers"
    static let ReplacePassword_Val3 = "User must not be empty"
    static let ReplacePassword_Val4 = "Email must be valid"
    static let ReplacePassword_Val5 = "Wrong previous password"
    static let ReplacePassword_Val6 = "Password was not repeated correctly"
}
