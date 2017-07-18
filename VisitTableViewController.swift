//
//  RootTableViewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/4/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import MIBadgeButton_Swift

import SVProgressHUD
import Alamofire
import ObjectMapper
import SwiftyJSON
class VisitTableViewController: UITableViewController {
    /**
     Tells the selected view controller with @a indexPath.
     
     @param indexPath
     The index path of the menu.
     */

    var m_VisitList = [Visit]()
    
    var m_Index : Int!
    
    var messageNotification : UIBarButtonItem!
    var bellNotification : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "menu_black-48") , style: .done, target: self, action: #selector(presentLeftMenu(_:)))
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.m_VisitfabButton?.show()

        self.commonInit();
        
        visitLoad()
        
    }
    func presentLeftMenu(_ sender : Any!){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.m_VisitfabButton?.hide()
        presentLeftMenuViewController(sender)
    }
    func visitLoad(){
        let parameter = ["userName" : Database.email]
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        
        Alamofire.request("\(APIInterface.VisitURL)?userName=\(Database.email!)", method: .get, headers: headers)
            .responseString{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                
                if (response.result.isSuccess){
                    let json = response.result.value!
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.m_VisitList = Mapper<Visit>().mapArray(JSONString: json)!
                        
                        for visit : Visit in self.m_VisitList
                        {
                            print(visit)
                        }
                        self.tableView.reloadData()

                    }
                    else{
                    }
                    
                }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.m_VisitfabButton?.show()
        visitLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Tabcontroller = segue.destination as! VisitTabController
        
        if m_Index >= 0{
            let currentVisit = m_VisitList[m_Index] as Visit
        
            let str : String = currentVisit.toJSONString()!
        
            
            Tabcontroller.is_CreateMode = false
            Tabcontroller.current_VisitID = currentVisit.idAsStr
        }
        if m_Index < 0 {
            Tabcontroller.is_CreateMode = true
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.m_VisitfabButton?.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return m_VisitList.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VisitItemCell
        // Configure the cell...
        cell.imageview.layer.masksToBounds = true
        cell.imageview.layer.cornerRadius = 40
        let currentVisit = m_VisitList[indexPath.row]
        cell.name.text = "\(currentVisit.drName!) (\(currentVisit.drType!))"
        cell.contenttext.text = currentVisit.title
        
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yy"
        let date = Date(milliseconds: currentVisit.startDate)
        cell.date.text = formater.string(from: date as Date)
        
        cell.alertimage.isHidden = currentVisit.alertCount > 0 ? false : true
        
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //performSegue(withIdentifier: "visitdetail", sender: self)
        m_Index = indexPath.row
        performSegue(withIdentifier: "VisitTabController", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    func updateScreen(){
        let bellBtn = bellNotification.customView as! MIBadgeButton
        let messageBtn = messageNotification.customView as! MIBadgeButton
        
        messageBtn.badgeString = "\(Database.userStatus.numOfUnreadMails!)"
        bellBtn.badgeString = "\(Database.userStatus.numOfActiveAlerts! + Database.userStatus.numOfExpiredReminders!)"
    }
    func commonInit(){

        
        let btn1 : MIBadgeButton = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        
        btn1.setImage(UIImage(named: "message"), for: .normal)        
        
        
        btn1.badgeEdgeInsets = UIEdgeInsetsMake(10, 15, 0, 15)
        btn1.badgeTextColor = UIColor.white
        btn1.badgeString = "0"
        btn1.badgeBackgroundColor = UIColor.red
        messageNotification = UIBarButtonItem(customView: btn1)
        
        let btn2 = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn2.setImage(UIImage(named: "bell"), for: .normal)
        //numOfActiveAlerts + numOfExpiredReminders
        
        btn2.badgeEdgeInsets = UIEdgeInsetsMake(10, 10, 0, 15)
        btn2.badgeTextColor = UIColor.white
        btn2.badgeString = "0"
        btn2.badgeBackgroundColor = UIColor.red
        bellNotification = UIBarButtonItem(customView: btn2)
        navigationItem.rightBarButtonItems = [bellNotification, messageNotification]
        
        self.addObservers()
        
        
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        
        Alamofire.request("\(APIInterface.UserManagementURL)/\(Database.email!)/status", method: .get, headers: headers)
            .responseString{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                if (response.result.isSuccess){
                    let json = response.result.value!
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        Database.userStatus = Mapper<UserStatus>().map(JSONString: response.result.value!)
                        btn1.badgeString = "\(Database.userStatus.numOfUnreadMails!)"
                        btn2.badgeString = "\(Database.userStatus.numOfActiveAlerts! + Database.userStatus.numOfExpiredReminders!)"
                        
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.runNotificationTimer()
                    }
                    else{
                    }
                    
                }
        }
        
    }


    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDeviceOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    func didDeviceOrientationChange(_ notification: Notification) {
        
    }
    
    func createNewVisit(){
        m_Index = -1
        performSegue(withIdentifier: "VisitTabController", sender: self)
    }
}
