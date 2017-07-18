//
//  UserDetailController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/12/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import SwiftyFORM
import SwiftyJSON
import ObjectMapper
import Alamofire
import SVProgressHUD
import CFAlertViewController
class LocationObject : Mappable{
    
    //public var totalResultsCount : Int?
    public var geonames : [GeoNamesObject]!
    
    required init?(map : Map){
        
    }
    func mapping(map: Map) {
        //totalResultsCount      <- map["totalResultsCount"]
        geonames                <- map["geonames"]
    }
}
class GeoNamesObject : Mappable{
    
    var numberOfChildren : Int!
    var lng : String!
    var geonameId : Int!
    var countryCode : String!
    var name : String!
    var toponymName : String!
    var lat : String!
    var fcl : String!
    var fcode : String!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        numberOfChildren    <- map["numberOfChildren"]
        lng                 <- map["lng"]
        geonameId           <- map["geonameId"]
        countryCode         <- map["countryCode"]
        name                <- map["name"]
        toponymName         <- map["toponymName"]
        lat                 <- map["lat"]
        fcl                 <- map["numberOfChildren"]
        fcode               <- map["fcode"]
    }
}

class UserDetailController: FormViewController {
    public var Country_Data : LocationObject!
    public var State_Data : LocationObject!
    public var City_Data : LocationObject!
    
    public var CountryPicker : OptionPickerFormItem!
    public var StatePicker : OptionPickerFormItem!
    public var CityPicker : OptionPickerFormItem!
    
    public var m_UserEntity : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(submitAction(_:)))
        //let moreBtn = UIBarButtonItem(title: "More>", style: .plain, target: self, action: #selector(moreAction(_:)))
        self.navigationItem.rightBarButtonItems = [/*moreBtn,*/doneBtn]
        
    }
    func moreAction(/*_ sender: AnyObject?*/) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MoreMedicalDetailController") as! MoreMedicalDetailController
        self.navigationController?.pushViewController(controller, animated: true)
        
        /*
        formBuilder.validateAndUpdateUI()
        
        let result = formBuilder.validate()
        
        if (password.value != retypepassword.value){
            let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Validation Status", message: "Password was not repeated correctly", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
            alertControler.addAction(CFAlertAction.action(title: "OK", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: nil))
            
            self.present(alertControler, animated: true, completion: nil)
        }
        else
        {
            self.showMoreResult(result)
        }
        */
        
    }
    
    func showMoreResult(_ result: FormBuilder.FormValidateResult) {
        switch result {
        case .valid:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MoreMedicalDetailController") as! MoreMedicalDetailController
            self.navigationController?.pushViewController(controller, animated: true)

            break
        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "Invalid"
            //form_simpleAlert(title, message)
            let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: title, message: message, textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
            alertControler.addAction(CFAlertAction.action(title: "OK", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: nil))
            
            self.present(alertControler, animated: true, completion: nil)
        }
    }
    
    func submitAction(_ sender: AnyObject?) {
        formBuilder.validateAndUpdateUI()
        let result = formBuilder.validate()
        
        if (password.value != retypepassword.value){
            let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Validation Status", message: "Password was not repeated correctly", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
            alertControler.addAction(CFAlertAction.action(title: "OK", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: nil))
            
            self.present(alertControler, animated: true, completion: nil)
        }
        else
        {
            self.showSubmitResult(result)
        }
        
        
    }
    
    func showSubmitResult(_ result: FormBuilder.FormValidateResult) {
        switch result {
        case .valid:
            makeUserEntity()
            break
        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "Invalid"
            //form_simpleAlert(title, message)
            let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: title, message: message, textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
            alertControler.addAction(CFAlertAction.action(title: "OK", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: nil))
            
            self.present(alertControler, animated: true, completion: nil)
        }
    }
    
    func makeUserEntity(){
        let date = Date()
        let millisecond = date.millisecondsSince1970
        
        let loc = Location(placeName: nil, country: CountryPicker.selected?.title, state: StatePicker.selected?.title, city: CityPicker.selected?.title, street: nil, numberInStreet: nil )
        
        
        m_UserEntity = User(location : loc,
                            userName: email.value,
                            email: nil,
                            phone: nil,
                            lastLoginDate: millisecond,
                            password: password.value,
                            userFullName: firstname.value + lastname.value,
                            dateOfBirth: birthday.value.millisecondsSince1970,
                            gender: (maleOrFemale.selected?.title)!,
                            language: "en-us",
                            termsIdsList: nil,
                            heightInCm: 0,
                            weightInKg: 0,
                            token: nil,
                            preliminary: false,
                            currentDiseases: nil,
                            currentMedications: nil,
                            currentInspections: nil,
                            idAsStr: nil,
                            isPregnant: PregnantSwitch.value,
                            isNursingMother: NursingSwitch.value,
                            isAdmin: false,
                            isTempPass: false)
        SVProgressHUD.show()
        
        let parameters = (m_UserEntity?.toJSON())! as [String : Any]
        
        Alamofire.request(APIInterface.UserManagementURL, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        
                        
                        let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Sign Up Status", message: "Successed for Sign up", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                        alertControler.addAction(CFAlertAction.action(title: "Go to Login Screen", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(alertControler, animated: true, completion: nil)
                    }
                    else{
                        
                    }
                    
                }
        }

        
    }
    
    func readJson() {
        
        var jsonData: Data?
        
        if let file = Bundle.main.path(forResource: "Country", ofType: "json") {
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
            
            print(JSON(jsonData!).rawString()!)
            
            let rawJSONstr = JSON(jsonData!).rawString()
            Country_Data = LocationObject(JSONString: rawJSONstr!)!
            
            
            
            
        } else {
            print("Fail")
        }
        
        

    }
    override func populate(_ builder: FormBuilder) {
        super.populate(builder)
        
        builder.navigationTitle = "Sign Up"
        builder.toolbarMode = .simple
        builder += SectionHeaderTitleFormItem().title("Email Setting")
        
        builder += email
    
        builder += SectionHeaderTitleFormItem().title("Password Setting")
        builder += password
        builder += retypepassword
        builder += SectionHeaderTitleFormItem().title("Personal Detail")
        builder += firstname
        builder += lastname
        builder += birthday
        builder += maleOrFemale
        builder += SectionHeaderTitleFormItem().title("User Detail")
        builder += PregnantSwitch
        builder += NursingSwitch
        builder += SectionHeaderTitleFormItem().title("User Location")
        
        readJson()
        
        CountryPicker = OptionPickerFormItem()
    
        CountryPicker.title("Country").placeholder("required")
        for i in 0...self.Country_Data.geonames.count - 1{
            CountryPicker.append(Country_Data.geonames[i].name)
            
        }
        CountryPicker.valueDidChange = { (selected: OptionRowModel?) in
            print("Country Selected: \(String(describing: selected))")
            self.didSelectCountry(selectedRow: self.GetIndexfromArray(object: self.Country_Data, name: (selected?.title)!))
        }
        
        StatePicker = OptionPickerFormItem()
        StatePicker.title("State").placeholder("required")
        StatePicker.valueDidChange = { (selected: OptionRowModel?) in
            print("State Selected: \(String(describing: selected))")
            self.didSelectState(selectedRow: self.GetIndexfromArray(object: self.State_Data, name: (selected?.title)!))
        }
        
        CityPicker = OptionPickerFormItem()
        CityPicker.title("City").placeholder("required")
        CityPicker.valueDidChange = { (selected: OptionRowModel?) in
            print("City Selected: \(String(describing: selected))")
        }
        
        builder += CountryPicker
        builder += StatePicker
        builder += CityPicker
        builder += SectionHeaderTitleFormItem().title("More Details are optional")
        builder += MoreButton
        builder.alignLeft([email, password, retypepassword, firstname, lastname,birthday,maleOrFemale])
    }
    
    func GetIndexfromArray(object : LocationObject, name : String ) -> Int{
        for i in 0...object.geonames.count - 1{
            if (object.geonames[i].name == name){
                return i
            }
        }
        return 0
    }
    
    func didSelectCountry(selectedRow : Int){
        print("SelectedRow\(selectedRow)")
        let Parameters = ["geonameId" : Country_Data.geonames[selectedRow].geonameId]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.LocationURL, method: .get, parameters: Parameters, encoding: URLEncoding.default, headers: nil)
            .responseString{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        
                        let StateStr = response.result.value
                        
                        self.State_Data = LocationObject(JSONString: StateStr!)
                        self.StatePicker.options.removeAll()
                        for i in 0...self.State_Data.geonames.count - 1{
                            self.StatePicker.append(self.State_Data.geonames[i].name)
                        }
                        self.CityPicker.options.removeAll()
                        //self.StatePicker.selectOptionWithTitle(self.State_Data.geonames[0].name)
                        //self.StatePicker.didChangeValue(forKey: self.State_Data.geonames[0].name)
                    }
                    else{
                    }
                    
                }
        }

        
    }
    func didSelectState(selectedRow : Int){
        let Parameters = ["geonameId" : State_Data.geonames[selectedRow].geonameId]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.LocationURL, method: .get, parameters: Parameters, encoding: URLEncoding.default, headers: nil)
            .responseString{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        
                        let StateStr = response.result.value
                        
                        self.City_Data = LocationObject(JSONString: StateStr!)
                        self.CityPicker.options.removeAll()
                        for i in 0...self.City_Data.geonames.count - 1{
                            self.CityPicker.append(self.City_Data.geonames[i].name)
                        }
                        //self.CityPicker.selectOptionWithTitle(self.City_Data.geonames[0].name)
                        //self.CityPicker.didChangeValue(forKey: self.City_Data.geonames[0].name)
                    }
                    else{
                    }
                    
                }
        }
    }
    var email: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Email").placeholder("required")
        instance.keyboardType = .emailAddress
        instance.softValidate(NotSpecification.init(CountSpecification.exactly(0)), message: "User must not be empty")
        instance.softValidate(EmailSpecification(), message: "Email is not valid")
        return instance
    }()
    lazy var password: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("New Password").password().placeholder("required")
        instance.keyboardType = .default
        instance.autocorrectionType = .no
        instance.softValidate(CountSpecification.between(6,20), message: "Password must be 6-20 characters")
        instance.submitValidate(NotSpecification.init(OrSpecification.init(CharacterSetSpecification.alphanumericCharacterSet(), CharacterSetSpecification.symbolCharacterSet())), message: "Password must be 6-20 characters , must contains uppercase and/or lowercase , can contain special characters (!@#$% ) and must contain numbers")
        return instance
    }()
    lazy var retypepassword: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Retype Password").password().placeholder("required")
        instance.keyboardType = .default
        instance.autocorrectionType = .no
        instance.softValidate(CountSpecification.between(6,20), message: "Password must be 6-20 characters")
        instance.submitValidate(NotSpecification.init(OrSpecification.init(CharacterSetSpecification.alphanumericCharacterSet(), CharacterSetSpecification.symbolCharacterSet())), message: "")
        return instance
    }()
    
    lazy var firstname: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("First Name").placeholder("Optional")
        instance.keyboardType = .default
        return instance
    }()
    lazy var lastname: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Last Name").placeholder("Optional")
        instance.keyboardType = .default
        return instance
    }()
    
    public func offsetDate(_ date: Date, years: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = years
        let calendar = Calendar.current
        guard let resultDate = calendar.date(byAdding: dateComponents, to: date) else {
            return date
        }
        return resultDate
    }
    
    lazy var birthday: DatePickerFormItem = {
        let today = Date()
        let instance = DatePickerFormItem()
        instance.title = "Birthday"
        instance.datePickerMode = .date
        instance.minimumDate = self.offsetDate(today, years: -150)
        instance.maximumDate = today
        return instance
    }()
    
    /*lazy var maleOrFemale: ViewControllerFormItem = {
        let instance = ViewControllerFormItem()
        instance.title("Male or Female").placeholder("required")
        instance.createViewController = { (dismissCommand: CommandProtocol) in
            let vc = MaleFemaleViewController(coder: dismissCommand as! NSCoder)
            return vc
        }
        instance.willPopViewController = { (context: ViewControllerFormItemPopContext) in
            if let x = context.returnedObject as? SwiftyFORM.OptionRowFormItem {
                context.cell.detailTextLabel?.text = x.title
            } else {
                context.cell.detailTextLabel?.text = nil
            }
        }
        return instance
    }()*/
    lazy var maleOrFemale: OptionPickerFormItem = {
        let instance = OptionPickerFormItem()

        instance.title("Gender").placeholder("required")
        instance.append("MALE").append("FEMALE")
        instance.selectOptionWithTitle("MALE")
        instance.valueDidChange = { (selected: OptionRowModel?) in
            print("Gender Selected: \(String(describing: selected))")
        }
        return instance
    }()
    lazy var PregnantSwitch: SwitchFormItem = {
        let instance = SwitchFormItem()
        instance.title = "Pregnant"
        instance.value = true
        return instance
    }()
    lazy var NursingSwitch: SwitchFormItem = {
        let instance = SwitchFormItem()
        instance.title = "Nursing"
        instance.value = true
        return instance
    }()
    
    lazy var MoreButton: ButtonFormItem = {
        let instance = ButtonFormItem()
        instance.title = "More Details"
        instance.action = { [weak self] in
            self?.moreAction()
            //self?.form_simpleAlert("Button 0", "Button clicked")
        }
        return instance
    }()
    /*var CountryPicker1 : OptionPickerFormItem = {
        let instance = OptionPickerFormItem()
        instance.title("Gender").placeholder("required")
        instance.append("Male").append("Female")
        
        
        
        instance.selectOptionWithTitle("Male")
        instance.valueDidChange = { (selected: OptionRowModel?) in
            print("Gender Selected: \(String(describing: selected))")
        }
        return instance
    }()*/

}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
