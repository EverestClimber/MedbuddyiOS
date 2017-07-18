//
//  AlertTableViewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/5/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import SwipeCellKit
class AlertTableViewController: UITableViewController {

    var m_AlertList : [Alert]! = []
    var index : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.commonInit();
        GetAlertEntityList()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }
    func rotated(){
        //tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {

        GetAlertEntityList()

    }


    
    func GetAlertEntityList(){
        let parameters = ["userName" : Database.email]
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.AlertURL+"?userName=\(Database.email!)", method: .get, headers: headers)
            .responseString{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                
                if (response.result.isSuccess){
                    let json = response.result.value
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        if (json != ""){
                            self.m_AlertList = Mapper<Alert>().mapArray(JSONString: json!)
                            self.tableView.reloadData()
                        }
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return m_AlertList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : AlertCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "alertcell", for: indexPath) as! AlertCell
        cell.delegate = self
        // Configure the cell...
        cell.title.text = m_AlertList[indexPath.row].alertType
        
        /*	CRITICAL,
         WARNING,
         INFO*/
        if (m_AlertList[indexPath.row].alertType != "REMINDER"){
            cell.alertIcon.isHidden = false
            cell.bellIcon.isHidden = true
            if m_AlertList[indexPath.row].severity == "CRITICAL"{
                //Red Alert
                cell.alertIcon.image = UIImage(named: "alert-red")
            }
            if m_AlertList[indexPath.row].severity == "WARNING"{
                //Orange Alert
                cell.alertIcon.image = UIImage(named: "alert-orange")
            }
            if m_AlertList[indexPath.row].severity == "INFO"{
                //Blue Alert
                cell.alertIcon.image = UIImage(named: "alert-blue")
            }
        }
        else
        {
            cell.alertIcon.isHidden = true
            cell.bellIcon.isHidden = false
            if m_AlertList[indexPath.row].reminderDetails.nextAlerttime < Date().millisecondsSince1970 {
                //Red Bell
                cell.bellIcon.image = UIImage(named: "bell-red")
                
            }
            else{
                // Blue Bell
                cell.bellIcon.image = UIImage(named: "bell-blue")
            }
        }
        cell.msgText.text = m_AlertList[indexPath.row].msg
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yy"
        
        cell.creationDate.text = formater.string(from: Date(milliseconds: m_AlertList[indexPath.row].creationDate))
        
        switch m_AlertList[indexPath.row].feedBack {
        case "NONE":
            cell.feedbackBtn.setImage(UIImage(named : "thumb-none"), for : .normal)
            cell.feedbackState = 0
        case "THUMB_UP":
            cell.feedbackBtn.setImage(UIImage(named : "thumb-up"), for: .normal)
            cell.feedbackState = 1
        case "THUMB_DOWN":
            cell.feedbackBtn.setImage(UIImage(named : "thumb-down"), for: .normal)
            cell.feedbackState = 2
        default:
            break
        }
        
        
        return cell
    }
    

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        
        if (m_AlertList[index].reminderDetails.recurring == false){
            performSegue(withIdentifier: "onetimealert", sender: self)
        }
        else{
            performSegue(withIdentifier: "recurringalert", sender: self)
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    func commonInit(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "menu_black-48") , style: .done, target: self, action: #selector(presentLeftMenuViewController(_:)))
        
        self.addObservers()
        
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDeviceOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    func didDeviceOrientationChange(_ notification: Notification) {
        
    }
    
    @IBAction func oncreaetNewAlert(_ sender: Any) {
        index = -1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let onetime = UIAlertAction(title: "OneTime Alert", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "onetimealert", sender: self)
            
        })
        let recurring = UIAlertAction(title: "Recurring Alert", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "recurringalert", sender: self)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        // 4
        optionMenu.addAction(onetime)
        optionMenu.addAction(recurring)
        optionMenu.addAction(cancel)
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onetimealert"{
            let controller = segue.destination as! AlertOneTimeController
            if (index >= 0){
                controller.alertObject = m_AlertList[index]
            }
            else{
                controller.alertObject = nil
            }
        }
        if segue.identifier == "recurringalert"{
            let controller = segue.destination as! AlertRecurringController
            if (index >= 0){
                controller.alertObject = m_AlertList[index]
            }
            else{
                controller.alertObject = nil
            }
        }
        
    }
    func deleteAlertRequest(indexpath : IndexPath){
        let alertObject = m_AlertList[indexpath.row]
        alertObject.active = false
        let parameters = alertObject.toJSON()
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        //print(alertObject.toJSONString())
        Alamofire.request(APIInterface.AlertURL, method: .put , parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.GetAlertEntityList()
                    }
                    else{
                        
                    }
                    
                }
        }
    }
    func updateAlertRequest(indexpath : IndexPath){
        let alertObject = m_AlertList[indexpath.row]
        switch (tableView.cellForRow(at: indexpath) as! AlertCell).feedbackState
        {
        case 0:
            alertObject.feedBack = "NONE"
        case 1:
            alertObject.feedBack = "THUMB_UP"
        case 2:
            alertObject.feedBack = "THUMB_DOWN"
        default:
            break
        }
        let parameters = alertObject.toJSON()
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        //print(alertObject.toJSONString())
        Alamofire.request(APIInterface.AlertURL, method: .put , parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.GetAlertEntityList()
                    }
                    else{
                        
                    }
                    
                }
        }
    }
}
extension AlertTableViewController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let delete = SwipeAction(style: .default, title: "Delete") { (action, indexpath) in
            self.deleteAlertRequest(indexpath: indexpath)
        }
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        delete.hidesWhenSelected = true
        let update = SwipeAction(style: .default, title: "Update") { (action, indexpath) in
            self.updateAlertRequest(indexpath : indexpath)
        }
        update.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        update.hidesWhenSelected = true
        return [delete,update]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.transitionStyle = .border
        return options
    }
}
