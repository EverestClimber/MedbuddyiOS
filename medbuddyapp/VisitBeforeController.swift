//
//  VisitBeforeController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/17/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka
import ISMessages
import SVProgressHUD
import ObjectMapper
import Alamofire
class VisitBeforeController: FormViewController ,DrDetailDelegate{

    var currentVisit : Visit!
    var is_CreateMode : Bool!
    
    var currentVisitID : String!
    var nameRowList : [TextAreaRow] = []
    var pointList : [PointForVisit]! = []
    var drType : PushRow = PushRow<String>("drtype") {
                $0.title = "Dr Type"
                $0.options = [
                              	"GENERAL" ,
                              	"DERMATLOGY",
                              	"RADIOLAGY",
                              	"Audiologist",
                              	"Allergist",
                              	"Andrologists",
                              	"Cardiologist",
                              	"Dentist",
                              	"Endocrinologist",
                              	"Gastroenterologist",
                              	"Hematologist" ,
                              	"Nephrologists",
                              	"Neurologist" ,
                              	"Rheumatologist",
                              	"Pediatrician",
                              	"Oncologist",
                              	"Ophthalmologist",
                              	"Orthopedist",
                              	"Urologist" ,
                              	"Gynecologist"]
                $0.value = "GENERAL"
        
                $0.selectorTitle = "Doctor"
        }
    var drDatePicker = DateInlineRow("date") {
        $0.title = "Date"

        $0.value = Date()
    }

    var drTimePicker = TimeInlineRow("time"){
        $0.title = "Time"
        $0.value = Date()
    }
    var drName = PushRow<String>(){
        $0.title = "Dr Name"
        $0.presentationMode = .segueName(segueName: "DoctorDetailController", onDismiss:nil)
        $0.value = "Required"
    }
    var visitTitle = TextAreaRow("title") {
        $0.placeholder = "Title"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
    }

    var pointSection : MultivaluedSection!
    var doctor : Doctor!
    var isDoctorCreate : Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        if is_CreateMode == true{
            
            self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
        }
        else{
            //self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(onDone))

        }
        
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.contentInset.top = 50
        pointSection = MultivaluedSection(multivaluedOptions: [.Reorder,.Insert,.Delete],
                                                  header: "Point Detail")
            {
             $0.addButtonProvider = { section in
                return ButtonRow(){
                    $0.title = "Add New Point"
             }.cellUpdate { cell, row in
             cell.textLabel?.textAlignment = .left
             }
             }
             $0.multivaluedRowToInsertAt = { index in
                return TextAreaRow() {
                    $0.placeholder = "Point Text"
                    $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                    self.nameRowList.append($0)
                }
             }
        }
        form
            +++ Section("Visit Title")
            <<< visitTitle
            .onChange({ (row) in
                ((self.tabBarController as! VisitTabController).childViewControllers[1] as! VisitProcessController).visitTitle.value = row.value
                ((self.tabBarController as! VisitTabController).childViewControllers[2] as! VisitSummaryController).visitTitle.value = row.value
            })
            +++ Section("Select Doctory Type")
            <<< drType.onChange({ (row) in
                if row.value == "NOT_SELECTED"
                {
                    
                }
                else{
                    
                }
            })
            +++ Section("Time Detail")
            <<< drDatePicker
            <<< drTimePicker
            <<< drName    
            +++ pointSection
        
        
        if (is_CreateMode == false){
            loadVisitDetail()
            
            
        }
        else{
            createMode()
        }
        
    }

    func onDone(){
        if is_CreateMode == true{
        if (self.isDoctorCreate == false){
            
            let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
            let parameters = doctor.toJSON()
            SVProgressHUD.show()
            Alamofire.request(APIInterface.DoctorCreateURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseString{ response in

                    SVProgressHUD.dismiss()
                    if (response.result.isSuccess){
                        let statusCode = response.response?.statusCode
                        if (statusCode! >= 200 && statusCode! < 300){
                            let dr = Mapper<Doctor>().map(JSONString: response.result.value!)
                            
                            self.createVisit(dr: self.doctor!)
                        }
                        else{
                        }
                    }
            }
        }
        else{
            self.createVisit(dr: doctor!)
        }
        }
        else{
            let doctorData = Doctor(name: currentVisit.drName, email: currentVisit.drEmail, drCategory: currentVisit.drType, drLocation: nil, namesList: [], idAsStr: "")
            self.createVisit(dr: doctorData)
        }
    }
    func createVisit(dr : Doctor){
        
        let calendar = Calendar.current
        
        let hour2 : Int = calendar.component(.hour, from: drTimePicker.value!)
        let min2 : Int = calendar.component(.minute, from: drTimePicker.value!)
        let sec2 : Int = calendar.component(.second, from: drTimePicker.value!)
        
        let dateOff : Int = 1000*60*60*hour2 + 1000*60*min2 + 1000*sec2
        
        let hour1 : Int = calendar.component(.hour, from: drDatePicker.value!)
        let min1 : Int = calendar.component(.minute, from: drDatePicker.value!)
        let sec1 : Int = calendar.component(.second, from: drDatePicker.value!)
        
        let dateMil : Int = (drDatePicker.value?.millisecondsSince1970)! - 1000*60*60*hour1 - 1000*60*min1 - 1000*sec1
        let date = Date(milliseconds: dateMil + dateOff)
        
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        
        pointList.removeAll()
        for nameRow in nameRowList{
            pointList.append( PointForVisit(pointText: nameRow.value, pointCategory: "MEDICINES", forSpecificDr: false, templatePoint: false, defaultPointKey: "", relevantDrTypes: [], idAsStr: "", deleted: false))
        }
        var method = HTTPMethod.post
        var parameters : [String: Any]!
        if is_CreateMode == true{
            method = HTTPMethod.post
            let newVisit = Visit(contentList : [],alerts : [], userName: Database.User.userName, startDate: date.millisecondsSince1970, preVisitPointsList: pointList, visitStatus: "New", drType: dr.drCategory, drKey: "", drEmail: dr.email, drName: dr.name, drPic: "", title: visitTitle.value, bodyArea: "BACK", language: "en-us", location: Database.User.location, allowedUserNames: [], alertCount: 0, idAsStr: nil)
            
            parameters = newVisit.toJSON()
        }
        else{
            method = HTTPMethod.put
            
            currentVisit.preVisitPointsList = pointList
            currentVisit.visitStatus = "InProgress"
            currentVisit.title = visitTitle.value
            parameters = currentVisit.toJSON()
        }
        
        print(parameters)
        SVProgressHUD.show()

        Alamofire.request(APIInterface.VisitURL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        print(response.result.value)
                        
                        //self.navigationController?.popViewController(animated: true)
                        //self.navigationController?.topViewController?.viewWillAppear(true)
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    else{
                    }
                    
                }
        }

    }
    func loadVisitDetail(){
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        var url = "\(APIInterface.VisitURL)/"
        url += currentVisitID
        Alamofire.request(url, method: .get,headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.currentVisit = Mapper<Visit>().map(JSONString: response.result.value!)
                        self.setFields()
                    }
                    else{
                    }
                    
                }
        }
    }
    func createMode(){
        
    }
    func setFields(){
        visitTitle.value = currentVisit.title
        drType.value = currentVisit.drType
        drDatePicker.value =  Date(milliseconds: currentVisit.startDate)
        drTimePicker.value = Date(milliseconds: currentVisit.startDate)
        drName.value = currentVisit.drName
        pointList = currentVisit.preVisitPointsList
        
        for index in 0...pointList.count - 1{
            nameRowList.append(TextAreaRow(){
                $0.value = pointList[index].pointText
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                $0.onChange({ (row) in
                    ISMessages.showCardAlert(withTitle: "Alert", message: "Cannot change doctor detail", duration: 2, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition:ISAlertPosition.top, didHide: nil)
                    row.value = self.pointList[index].pointText
                })
            })
        }
        
        
        
        for index in 0 ... nameRowList.count - 1{
            pointSection.insert(nameRowList[index], at: index)
        }
        
        //pointSection.multivaluedOptions = [MultivaluedOptions.Reorder]
        
        tableView.reloadData()
        
        drType.onChange { (row) in
            
            ISMessages.showCardAlert(withTitle: "Alert", message: "Cannot change doctor detail", duration: 2, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition:ISAlertPosition.top, didHide: nil)
            self.drType.value = self.currentVisit.drType
            self.drType.reload()
        }
        
        drDatePicker.onChange { (row) in
            ISMessages.showCardAlert(withTitle: "Alert", message: "Cannot change doctor detail", duration: 2, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition:ISAlertPosition.top, didHide: nil)
            self.drDatePicker.value = Date(milliseconds: self.currentVisit.startDate/1000)
        }
        drTimePicker.onChange { (row) in
            ISMessages.showCardAlert(withTitle: "Alert", message: "Cannot change doctor detail", duration: 2, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition:ISAlertPosition.top, didHide: nil)
            self.drTimePicker.value = Date(milliseconds: self.currentVisit.startDate/1000)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if is_CreateMode == false {
            (segue.destination as! DoctorDetailController).currentVisit = currentVisit
            (segue.destination as! DoctorDetailController).is_CreateMode = is_CreateMode
        }
        else{
            (segue.destination as! DoctorDetailController).is_CreateMode = is_CreateMode
        }
        (segue.destination as! DoctorDetailController).drType = self.drType.value
        (segue.destination as! DoctorDetailController).delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDoctorDetail(doctor : Doctor,mode : Bool){
        self.doctor = doctor
        self.isDoctorCreate = mode
        drName.value = self.doctor.name
    }
}
