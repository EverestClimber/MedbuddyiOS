//
//  DoctorDetailController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/17/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import ObjectMapper
import SVProgressHUD
import ISMessages
import SwiftyJSON
protocol DrDetailDelegate : class{
    func setDoctorDetail(doctor : Doctor, mode : Bool)
}
struct SuggestDoctor {
    
    var name: String!
    var email: String!
    var drCategory: String!
    var drLocation: Location!
    var namesList: [String]!
    
    init(name : String!, email : String!, drCategory : String!, drLocation : Location!, namesList : [String]!) {
        self.name = name
        self.email = email
        self.drCategory = drCategory
        self.drLocation = drLocation
        self.namesList = namesList
    }
}
extension SuggestDoctor: SuggestionValue {
    // Required by `InputTypeInitiable`, can always return nil in the SuggestionValue context.
    init?(string stringValue: String) {
        return nil
    }
    
    // Text that is displayed as a completion suggestion.
    var suggestionString: String {
        return name
    }

}
func == (lhs: SuggestDoctor, rhs: SuggestDoctor) -> Bool {
    return lhs.name == rhs.name
}
class DoctorDetailController: FormViewController {

    var delegate : DrDetailDelegate!
    var is_CreateMode : Bool!
    
    var currentVisit : Visit!
    
    var currentDr : Doctor!
    var DoctorArray : [SuggestDoctor]! = []
    
    var drType : String!
    
    var createMode : SwitchRow!
    var suggest_Row : SuggestionAccessoryRow<SuggestDoctor>!
    var drNameRow : NameRow!
    var emailRow : EmailRow!
    var phoneRow : PhoneRow!
    var stateRow : PushRow<String>!
    var cityRow : PushRow<String>!
    
    var placeRow : TextRow!
    var addressRow : TextRow!
    
    var Country_Data : LocationObject!
    var State_Data : LocationObject!
    var City_Data : LocationObject!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        navigationItem.title = drType
        
        
        
        
        
        if is_CreateMode == true{
            
            form +++
                Section("Please Select Doctor Mode")
                <<< SwitchRow(){
                    $0.title = "Create/Non-Create"
                    $0.tag = "DrSelMode"
                    $0.value = false
                    if (self.is_CreateMode == false){
                        //$0.hidden = true
                        form.sectionBy(tag: "Section0")?.hidden = true
                    }
                    
                    
                    }
                    .onChange({ (row) in
                        if (self.DoctorArray.count == 0){
                            row.value = false
                            ISMessages.showCardAlert(withTitle: "No Suggesting Doctor", message: "Cannot change to doctor suggest Mode", duration: 2, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition:ISAlertPosition.top, didHide: nil)
                            row.reload()
                        }
                        
                    })
                +++ Section("Dr Detail")
                <<< SuggestionAccessoryRow<SuggestDoctor>("DrSuggestName") {
                    $0.filterFunction = {text in self.DoctorArray.filter({$0.name.lowercased().contains(text.lowercased())})}
                    $0.title = "Dr Name"
                    $0.placeholder = "Dr Name"
                    $0.hidden = "$DrSelMode == false"
                    }.onChange({ (row) in
                        
                    })
                <<< NameRow(){
                    $0.title = "Dr Name"
                    $0.tag = "DrNameRow"
                    $0.placeholder = "Required"
                    $0.hidden = "$DrSelMode == true"
                }
                <<< EmailRow(){
                    $0.title = "Dr Email"
                    $0.tag = "DrEmail"
                    $0.placeholder = "Required"
                    $0.disabled = "$DrSelMode == true"
                }
                <<< PhoneRow(){
                    $0.title = "Dr PhoneNum"
                    $0.tag = "DrPhoneNum"
                    $0.placeholder = "Required"
                    $0.disabled = "$DrSelMode == true"
                }
                +++ Section("Location")
                <<< PushRow<String>(){
                    $0.title = "State"
                    $0.tag = $0.title
                    $0.disabled = "$DrSelMode == true"
                    }.onPresent({ (_, vc) in
                        vc.enableDeselection = false
                        vc.dismissOnSelection = false
                    })
                <<< PushRow<String>(){
                    $0.title = "City"
                    $0.tag = $0.title
                    $0.disabled = "$DrSelMode == true"
                    }.onPresent({ (_, vc) in
                        vc.enableDeselection = false
                        vc.dismissOnSelection = false
                    })
                <<< TextRow(){
                    $0.title = "PlaceName"
                    $0.tag = $0.title
                    $0.placeholder = "Required"
                    $0.disabled = "$DrSelMode == true"
                }
                <<< TextRow(){
                    $0.title = "Address"
                    $0.tag = $0.title
                    $0.placeholder = "Required"
                    $0.disabled = "$DrSelMode == true"
            }
            
            self.createMode = form.rowBy(tag: "DrSelMode") as! SwitchRow
            self.suggest_Row = form.rowBy(tag: "DrSuggestName") as! SuggestionAccessoryRow<SuggestDoctor>
            self.drNameRow = form.rowBy(tag: "DrNameRow") as! NameRow
            self.emailRow = form.rowBy(tag: "DrEmail") as! EmailRow
            self.phoneRow = form.rowBy(tag: "DrPhoneNum") as! PhoneRow
            self.stateRow = form.rowBy(tag: "State") as! PushRow<String>
            self.cityRow = form.rowBy(tag: "City") as! PushRow<String>
            self.placeRow = form.rowBy(tag: "PlaceName") as! TextRow
            self.addressRow = form.rowBy(tag: "Address") as! TextRow
            
            getDrCandidate()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
            
            self.stateRow.value = Database.User.location.state
            self.cityRow.value = Database.User.location.city
            self.suggest_Row.onChange({ (row) in
                self.emailRow.value = row.value?.email
                self.phoneRow.value = ""
                self.stateRow.value = row.value?.drLocation.state
                self.cityRow.value = row.value?.drLocation.city
                self.placeRow.value = row.value?.drLocation.placeName
                self.addressRow.value = row.value?.drLocation.street
                
                self.tableView.reloadData()
            })
            
            self.stateRow.onChange({ (row) in
                for i in 0 ... self.State_Data.geonames.count-1{
                    if self.State_Data.geonames[i].name == self.stateRow.value{
                        self.didSelectState(selectedRow: i)
                    }
                }
            })
            self.stateRow.value = Database.User.location.state
            
            self.cityRow.value = Database.User.location.city
            
            readJson()
        }
        else
        {
            form +++

                 Section("Dr Detail")
                <<< NameRow(){
                    $0.title = "Dr Name"
                    $0.tag = "DrNameRow"
                    $0.placeholder = "Required"
                    $0.disabled = true
                }
                <<< EmailRow(){
                    $0.title = "Dr Email"
                    $0.tag = "DrEmail"
                    $0.placeholder = "Required"
                    $0.disabled = true
                }
                <<< PhoneRow(){
                    $0.title = "Dr PhoneNum"
                    $0.tag = "DrPhoneNum"
                    $0.placeholder = "Required"
                    $0.disabled = true
                }
                +++ Section("Location")
                <<< PushRow<String>(){
                    $0.title = "State"
                    $0.tag = $0.title
                    $0.disabled = true
                    }.onPresent({ (_, vc) in
                        vc.enableDeselection = false
                        vc.dismissOnSelection = false
                    })
                <<< PushRow<String>(){
                    $0.title = "City"
                    $0.tag = $0.title
                    $0.disabled = true
                    }.onPresent({ (_, vc) in
                        vc.enableDeselection = false
                        vc.dismissOnSelection = false
                    })
                <<< TextRow(){
                    $0.title = "PlaceName"
                    $0.tag = $0.title
                    $0.placeholder = "Required"
                    $0.disabled = true
                }
                <<< TextRow(){
                    $0.title = "Address"
                    $0.tag = $0.title
                    $0.placeholder = "Required"
                    $0.disabled = true
            }
            self.drNameRow = form.rowBy(tag: "DrNameRow") as! NameRow
            self.emailRow = form.rowBy(tag: "DrEmail") as! EmailRow
            self.phoneRow = form.rowBy(tag: "DrPhoneNum") as! PhoneRow
            self.stateRow = form.rowBy(tag: "State") as! PushRow<String>
            self.cityRow = form.rowBy(tag: "City") as! PushRow<String>
            self.placeRow = form.rowBy(tag: "PlaceName") as! TextRow
            self.addressRow = form.rowBy(tag: "Address") as! TextRow
            getDrDetail()
        }
        
    }
    func onDone(){
        let name : String!
        if (self.createMode.value == false){
            name = self.drNameRow.value!
        }
        else{
            name = self.suggest_Row.value?.name
        }
        let dr : Doctor = Doctor(name: name, email: self.emailRow.value, drCategory: self.drType, drLocation: Location(placeName: placeRow.value, country: Database.User.location.country, state: stateRow.value , city: cityRow.value, street: addressRow.value, numberInStreet: ""), namesList: [], idAsStr : "")
        delegate.setDoctorDetail(doctor: dr, mode: self.createMode.value!)
        navigationController?.popViewController(animated: true)
    }
    
    func getDrCandidate(){  ///OnCreate
        var parameters : [String : String]!
        if Database.User.location.state == nil{
            parameters = ["country" : Database.User.location.country!,"prefix" : "Dr"]
        }
        else{
            parameters = ["country" : Database.User.location.country!, "state" : Database.User.location.state!,"prefix" : "Dr"]
        }
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        DoctorArray.removeAll()
        Alamofire.request(APIInterface.DoctorListURL, method: .get,parameters : parameters, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        let list : [Doctor] = Mapper<Doctor>().mapArray(JSONString: response.result.value!)!
                        
                        
                        for doctor : Doctor in list{
                            if (doctor.drCategory == self.drType){
                                self.DoctorArray.append(SuggestDoctor(name: doctor.name, email: doctor.email, drCategory: doctor.drCategory, drLocation: doctor.drLocation, namesList: doctor.namesList))
                            }
                        }
                        
                        
                    }
                    else{
                    }
                    
                }
        }
    }
    func getDrDetail(){  ///
        var parameters : [String : String]!
        
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        var url = "\(APIInterface.DoctorURL)/"
        url += currentVisit.drKey!
        Alamofire.request(url, method: .get, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.currentDr = Mapper<Doctor>().map(JSONString: response.result.value!)
                        self.setField()
                    }
                    else{
                    }
                    
                }
        }
    }
    func setField(){
        

        
        drNameRow.value = currentDr.name
        emailRow.value = currentDr.email
        phoneRow.value = ""
        stateRow.value = currentDr.drLocation.state
        cityRow.value = currentDr.drLocation.city
        placeRow.value = currentDr.drLocation.placeName
        addressRow.value = currentDr.drLocation.street
        
        tableView.reloadData()
        
    }
    func readJson() {
        
        var jsonData: Data?
        
        if let file = Bundle.main.path(forResource: "Country", ofType: "json") {
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
            
            print(JSON(jsonData!).rawString()!)
            
            let rawJSONstr = JSON(jsonData!).rawString()
            Country_Data = LocationObject(JSONString: rawJSONstr!)!
    
                for i in 0 ... Country_Data.geonames.count-1{
                    if Country_Data.geonames[i].name == Database.User.location.country!{
                        didSelectCountry(selectedRow: i)
                    }
                }
            
            
            

        } else {
            print("Fail")
        }
    }
    
    func didSelectCountry(selectedRow : Int){
        print("SelectedRow\(selectedRow)")
        self.stateRow.options.removeAll()
        self.cityRow.options.removeAll()
        let Parameters = ["geonameId" : Country_Data.geonames[selectedRow].geonameId]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.LocationURL, method: .get, parameters: Parameters, encoding: URLEncoding.default, headers: nil)
            .responseString{ response in
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        let StateStr = response.result.value
                        self.State_Data = LocationObject(JSONString: StateStr!)
                        
                        for i in 0 ... self.State_Data.geonames.count-1{
                            self.stateRow.options.append(self.State_Data.geonames[i].name)
                        }
                        
                        for i in 0 ... self.State_Data.geonames.count-1{
                            if self.State_Data.geonames[i].name == self.stateRow.value{
                                self.didSelectState(selectedRow: i)
                            }
                        }
                        //self.stateRow.reload()
                        self.tableView.reloadData()
                    }
                    else{
                    }
                    
                }
        }
        
        
    }
    func didSelectState(selectedRow : Int){
        self.cityRow.options.removeAll()
        let Parameters = ["geonameId" : State_Data.geonames[selectedRow].geonameId]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.LocationURL, method: .get, parameters: Parameters, encoding: URLEncoding.default, headers: nil)
            .responseString{ response in
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        
                        let StateStr = response.result.value
                        
                        self.City_Data = LocationObject(JSONString: StateStr!)
                        
                        for i in 0 ... self.City_Data.geonames.count-1{
                            self.cityRow.options.append(self.City_Data.geonames[i].name)
                        }
                        //self.cityRow.reload()
                        self.tableView.reloadData()
                    }
                    else{
                    }
                    
                }
        }
    }

}
