//
//  AlertOneTimeController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/30/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka
import SVProgressHUD
import Eureka
import ObjectMapper
import Alamofire
class AlertOneTimeController: FormViewController {

    var reminderContentRow : TextAreaRow!
    var dateRow : DateInlineRow!
    var hourRow : TimeInlineRow!
    
    var alertObject : Alert!
    var is_createMode : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++
            Section("Reminder Content")
            <<< TextAreaRow("ReminderContent") {
            $0.tag = "ReminderContent"
            $0.placeholder = "E.g Take Medicine ... or Appointment with DR"
            
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 40)
        }
        +++ Section("Time Detail")
            <<< DateInlineRow("Date") {
                $0.title = "Date"
                $0.value = Date()
        }
            <<< TimeInlineRow("Hour"){
                $0.title = "Hour"
                $0.value = Date()
        }
        
        reminderContentRow = form.rowBy(tag: "ReminderContent") as! TextAreaRow
        dateRow = form.rowBy(tag: "Date")
        hourRow = form.rowBy(tag: "Hour")
        
        if alertObject != nil{
            reminderContentRow.value = alertObject.msg
            dateRow.value = Date(milliseconds: alertObject.reminderDetails.dueDate)
            hourRow.value = Date(milliseconds: alertObject.reminderDetails.dueDate)
            is_createMode = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(onDone))
        }
        else{
            is_createMode = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(onDone))
            
            
            
            
            
            
        }
        
    }

    func onDone(){
        
        var method : HTTPMethod!
        let calendar = Calendar.current
        
        let hour2 : Int = calendar.component(.hour, from: hourRow.value!)
        let min2 : Int = calendar.component(.minute, from: hourRow.value!)
        let sec2 : Int = calendar.component(.second, from: hourRow.value!)
        
        let dateOff : Int = 1000*60*60*hour2 + 1000*60*min2 + 1000*sec2
        
        let hour1 : Int = calendar.component(.hour, from: dateRow.value!)
        let min1 : Int = calendar.component(.minute, from: dateRow.value!)
        let sec1 : Int = calendar.component(.second, from: dateRow.value!)
        
        let dateMil : Int = (dateRow.value?.millisecondsSince1970)! - 1000*60*60*hour1 - 1000*60*min1 - 1000*sec1
        let date = Date(milliseconds: dateMil + dateOff)
        
        if is_createMode == false{
            method = .put
            alertObject.msg = reminderContentRow.value
            alertObject.reminderDetails.dueDate = date.millisecondsSince1970
            alertObject.reminderDetails.nextAlerttime = date.millisecondsSince1970
        }
        else{
            method = .post
            
            
            let reminder = ReminderDetails(recurring: false, dueDate: date.millisecondsSince1970, recurringType: "DAILY", nextAlerttime: date.millisecondsSince1970, alertId: "", active: false, hoursInDayToRemind: [], daysInWeekToRemind: [], daysInMonthToRemind: [])
            
            
            alertObject = Alert(userId: Database.email, visitID: "", alertType: "REMINDER", msg: reminderContentRow.value, severity: "INFO", reminderDetails: reminder, active: true, feedBack: "NONE", creationDate: Date().millisecondsSince1970, idAsStr: "")
        }
        
        let parameters = alertObject.toJSON()
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        //print(alertObject.toJSONString())
        Alamofire.request(APIInterface.AlertURL, method: method , parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        
                    }
                    
                }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
