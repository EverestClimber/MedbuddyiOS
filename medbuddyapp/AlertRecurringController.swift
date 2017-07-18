//
//  AlertRecurringController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/30/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Alamofire
import SVProgressHUD
class AlertRecurringController: FormViewController {

    var reminderContentRow : TextAreaRow!
    var specHourSection : MultivaluedSection!
    var weekdayRow : WeekDayRow!
    
    var timeRowArray : [PickerInlineRow<Int>]! = []
    var alertObject : Alert!
    var is_createMode : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++
        Section("Reminder Content")
            <<< TextAreaRow{
                $0.tag = "ReminderContent"
                $0.placeholder = "E.g Take Medicine ... or Appointment with DR"
                
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 40)
        }
            +++ MultivaluedSection(multivaluedOptions: [.Insert,.Reorder,.Delete], header: "Specific Hours"){
                $0.tag = "spechours"
                $0.multivaluedRowToInsertAt = { index in
                    return  PickerInlineRow<Int>{ (row : PickerInlineRow<Int>) -> Void in
                            row.title = "Hour"
                            row.displayValueFor = {(rowValue: Int?) in
                                return rowValue.map { _ in "\(rowValue!):00" }
                            }
                            row.options = []
                            var i : Int = 0
                            for _ in 1...24{
                                row.options.append(i)
                                i = i + 1
                            }
                            row.value = row.options[0]
                            self.timeRowArray.append(row)
                    }
                }
                
        }
        +++ Section("WeekDay cell")
            <<< WeekDayRow(){
                $0.tag = "weekdaycell"
                $0.value = [.monday,.tuesday,.wednesday,.thursday,.friday,.saturday,.sunday]
                
        }

        reminderContentRow = form.rowBy(tag: "ReminderContent")
        specHourSection = form.sectionBy(tag: "spechours") as! MultivaluedSection!
        weekdayRow = form.rowBy(tag: "weekdaycell")
        
        if alertObject != nil{
            is_createMode = false
            reminderContentRow.value = alertObject.msg
            let hourArray = alertObject.reminderDetails.hoursInDayToRemind as [Int]
            let daysArray = alertObject.reminderDetails.daysInWeekToRemind as [Int]
            
            //specHourSection
            if (hourArray.count > 0){
                for index : Int in 0...hourArray.count - 1{
                    specHourSection.insert(PickerInlineRow<Int>{ (row : PickerInlineRow<Int>) -> Void in
                        row.title = "Time"
                        row.displayValueFor = {(rowValue: Int?) in
                            return rowValue.map { _ in "\(rowValue!):00" }
                        }
                        row.options = []
                        var i : Int = 0
                        for _ in 1...24{
                            row.options.append(i)
                            i = i + 1
                        }
                        row.value = hourArray[index]
                        timeRowArray.append(row)
                    }, at: index)
                }
            }
            
            if daysArray.count > 0{
                var days = Set<WeekDay>()
                for index : Int in 0...daysArray.count - 1{
                    switch daysArray[index] {
                    case 1:
                        days.insert(WeekDay.monday)
                    case 2:
                        days.insert(WeekDay.tuesday)
                    case 3:
                        days.insert(WeekDay.wednesday)
                    case 4:
                        days.insert(WeekDay.thursday)
                    case 5:
                        days.insert(WeekDay.friday)
                    case 6:
                        days.insert(WeekDay.saturday)
                    case 7:
                        days.insert(WeekDay.sunday)
                    default:
                        break
                    }
                }
                weekdayRow.value = days
                
            }
            let updateBtn = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(onDone))
            let snoozeBtn = UIBarButtonItem(title: "Snooze", style: .done, target: self, action: #selector(onSnooze))
            self.navigationItem.rightBarButtonItems = [updateBtn, snoozeBtn]
            
        }
        else
        {
            is_createMode = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(onDone))
        }
    }
    func onSnooze(){
        let nextAlerttime = Date().millisecondsSince1970 + 10 * 1000 * 60
        
        alertObject.reminderDetails.nextAlerttime = nextAlerttime
        let parameters = alertObject.toJSON()
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.AlertURL, method: .put , parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    func onDone(){
        
        var method : HTTPMethod!
        var dueDate = Date()
        let calendar = Calendar.current
        
        var rec_Type : String?
        var hourinday : [Int] = []
        var dayinweek : [Int] = []
        if weekdayRow.value?.count == 7{
            rec_Type = "DAILY"
            dayinweek = [1,2,3,4,5,6,7]
        }
        else{
            rec_Type = "WEEKLY"
            for day : WeekDay in weekdayRow.value!{
                switch day {
                case WeekDay.monday:
                    dayinweek.append(1)
                case WeekDay.tuesday:
                    dayinweek.append(2)
                case WeekDay.wednesday:
                    dayinweek.append(3)
                case WeekDay.thursday:
                    dayinweek.append(4)
                case WeekDay.friday:
                    dayinweek.append(5)
                case WeekDay.saturday:
                    dayinweek.append(6)
                case WeekDay.sunday:
                    dayinweek.append(7)
                default:
                    break
                }
                
            }
        }
        for timeRow : PickerInlineRow<Int> in timeRowArray{
            if specHourSection.contains(timeRow) == true{
                hourinday.append(timeRow.value!)
            }
        }
        
        hourinday = hourinday.sorted(){$0 < $1}
        
        
        let currentHour : Int = calendar.component(.hour, from: dueDate)
        if hourinday.count > 0
        {
            var index : Int = -1
            for i in 0...hourinday.count - 1{
                if currentHour < hourinday[i]{
                    index = i
                    break
                }
            }
            if index == -1
            {
                index = 0
                let houroff = hourinday[0] + 24 - currentHour
                dueDate = calendar.date(byAdding: .hour, value: houroff, to: dueDate)!
            }
            else
            {
                let houroff = hourinday[index]  - currentHour
                dueDate = calendar.date(byAdding: .hour, value: houroff, to: dueDate)!
            }
            
        }
            
        else
        {
            
        }
        
        dayinweek = dayinweek.sorted(){$0 < $1}
        
        var currentDateinWeek = calendar.component(.weekday, from: Date()) - 1
        if (currentDateinWeek == 0)
        {
            currentDateinWeek = 7
        }
        
        
        if (currentDateinWeek == 0)
        {
            currentDateinWeek = 7
        }
        
        if (dayinweek.count > 0)
        {
            var index : Int = -1
            for i in 0...dayinweek.count - 1{
                if currentDateinWeek <= dayinweek[i]{
                    index = i
                    break
                }
            }
            if index == -1
            {
                index = 0
                let dayoff = dayinweek[0] + 7 - currentDateinWeek
                dueDate = calendar.date(byAdding: .day, value: dayoff, to: dueDate)!
            }
            else
            {
                let dayoff = dayinweek[index] - currentDateinWeek
                dueDate = calendar.date(byAdding: .day, value: dayoff, to: dueDate)!
                dueDate.millisecondsSince1970
            }
            
            
        }
        else
        {
            
        }
        
        
        let dueDateMils = dueDate.millisecondsSince1970 - (calendar.component(.minute, from: dueDate) * 1000*60 + calendar.component(.second, from: dueDate) * 1000)
        
        
        
        
        if is_createMode == false{
            method = HTTPMethod.put
            alertObject.msg = reminderContentRow.value
            alertObject.reminderDetails.dueDate = dueDateMils
            alertObject.reminderDetails.nextAlerttime = dueDateMils
            alertObject.reminderDetails.hoursInDayToRemind = hourinday
            alertObject.reminderDetails.daysInWeekToRemind = dayinweek
        }
        else{
            method = HTTPMethod.post
            
            let reminder = ReminderDetails(recurring: true, dueDate: dueDateMils, recurringType: rec_Type, nextAlerttime: dueDateMils, alertId: "", active: true, hoursInDayToRemind: hourinday, daysInWeekToRemind: dayinweek, daysInMonthToRemind: [])
            print(reminderContentRow.value)
            
            alertObject = Alert(userId: Database.email, visitID: "", alertType: "REMINDER", msg: reminderContentRow.value, severity: "INFO", reminderDetails: reminder, active: true, feedBack: "NONE", creationDate: Date().millisecondsSince1970, idAsStr: "")
            
        }
        
        let parameters = alertObject.toJSON()
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        print(alertObject.toJSONString())
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
