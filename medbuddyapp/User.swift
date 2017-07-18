//
//  User.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 private Location location;
	private String userName;
	private String email;
	private String phone;
	private Date lastLoginDate;
 
	private String password;
	private String userFullName;
	//@JsonForma(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd,HH:00", timezone="CET")
	private Date dateOfBirth;
	private EGender gender;
	private String language;
	private List<TermForUserKeyTuple> _currentDiseases;
	private List<TermForUserKeyTuple> _currentMedications;
 private List<TermForUserKeyTuple> _currentInspections;
	private  List<String> termsIdsList;
	private int heightInCm;
	private int weightInKg;
	@JsonProperty("isPregnant")
	private boolean _isPregnant;
	@JsonProperty("isNursingMother")
	private boolean _isNursingMother;
	@JsonProperty("isAdmin")
	private boolean _isAdmin;
	private String token;
	@JsonProperty("isTempPass")
	private boolean _isTempPass;
	private boolean isPreliminary;*/
class User : Mappable{
    var location : Location!
    var userName : String!
    var email : String?
    var phone : String?
    var lastLoginDate : Int!
    var password : String!
    var userFullName : String?
    var dateOfBirth : Int!
    var gender : String!
    var language : String!
    var termsIdsList : [String]?
    var heightInCm : Int!
    var weightInKg : Int!
    var token : String?
    var preliminary : Bool!
    var currentDiseases : [TermForUserKeyTuple]?
    var currentMedications : [TermForUserKeyTuple]?
    var currentInspections : [TermForUserKeyTuple]?
    var idAsStr : String?
    var isPregnant : Bool!
    var isNursingMother : Bool!
    var isAdmin : Bool!
    var isTempPass : Bool!
    
    init(location : Location!, userName : String,email : String?,phone : String?,lastLoginDate : Int,password : String,userFullName : String?,dateOfBirth :Int,gender : String,language : String,termsIdsList : [String]?,heightInCm : Int,weightInKg : Int,token : String?,preliminary : Bool,currentDiseases : [TermForUserKeyTuple]?,currentMedications : [TermForUserKeyTuple]?,currentInspections : [TermForUserKeyTuple]?,idAsStr : String?,isPregnant : Bool,isNursingMother : Bool,isAdmin : Bool,isTempPass : Bool) {
        
        self.location = location
        self.userName = userName
        self.email = email
        self.phone = phone
        self.lastLoginDate = lastLoginDate
        self.password = password
        self.userFullName = userFullName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.language = language
        self.termsIdsList = termsIdsList
        self.heightInCm = heightInCm
        self.weightInKg = weightInKg
        self.token = token
        self.preliminary = preliminary
        self.currentDiseases = currentDiseases
        self.currentMedications = currentMedications
        self.currentInspections = currentInspections
        self.idAsStr = idAsStr
        self.isPregnant = isPregnant
        self.isNursingMother = isNursingMother
        self.isAdmin = isAdmin
        self.isTempPass = isTempPass
    }
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        location                <- map["location"]
        userName                <- map["userName"]
        email                   <- map["email"]
        phone                   <- map["phone"]
        lastLoginDate           <- map["lastLoginDate"]
        password                <- map["password"]
        userFullName            <- map["userFullName"]
        dateOfBirth             <- map["dateOfBirth"]
        gender                  <- map["gender"]
        language                <- map["language"]
        termsIdsList            <- map["termsIdsList"]
        heightInCm              <- map["heightInCm"]
        weightInKg              <- map["weightInKg"]
        token                   <- map["token"]
        preliminary             <- map["preliminary"]
        currentDiseases         <- map["currentDiseases"]
        currentMedications      <- map["currentMedications"]
        currentInspections      <- map["currentInspections"]
        idAsStr                 <- map["idAsStr"]
        isPregnant              <- map["isPregnant"]
        isNursingMother         <- map["isNursingMother"]
        isAdmin                 <- map["isAdmin"]
        isTempPass              <- map["isTempPass"]
    }
}
