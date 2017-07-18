//
//  MessageTableViewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/5/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SVProgressHUD
import SwipeCellKit
class MessageTableViewController: UITableViewController  {

    
    var m_MsgList : [MailMsg]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.commonInit();
        self.GetMailMessages()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.GetMailMessages()
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
        return m_MsgList.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "messagedetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as! MessageTableViewCell
        // Configure the cell...
        cell.delegate = self
        
        if m_MsgList[indexPath.row].toUserName == Database.email{
            cell.message_source.text = "From : "
            cell.userName.text = m_MsgList[indexPath.row].fromUserName
        }
        if m_MsgList[indexPath.row].fromUserName == Database.email{
            cell.message_source.text = "To : "
            cell.userName.text = m_MsgList[indexPath.row].toUserName
        }
        if m_MsgList[indexPath.row].forPatientsLikeMe == true{
            cell.message_source.text = "From : "
            cell.userName.text = "Patients like me accordingly"
        }
        if m_MsgList[indexPath.row].replyForPatientsLikeMe == true{
            cell.message_source.text = "To : "
            cell.userName.text = "Patients like me accordingly"
        }
        
        if cell.message_source.text == "From : "{
            cell.message_direction.image = UIImage(named: "backward")
        }
        else
        {
            cell.message_direction.image = UIImage(named: "forward")
        }
        
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yy"
        
        cell.sendDate.text = formater.string(from: Date(milliseconds: m_MsgList[indexPath.row].sentdate))
        if m_MsgList[indexPath.row].read == false{
            cell.message_content.font = UIFont.boldSystemFont(ofSize: 13)
            cell.message_source.font = UIFont.boldSystemFont(ofSize: 15)
            cell.userName.font = UIFont.boldSystemFont(ofSize: 15)
            cell.sendDate.font = UIFont.boldSystemFont(ofSize: 15)
        }
        else{
            
        }
        cell.message_content.text = m_MsgList[indexPath.row].msgTitle + "\n" + m_MsgList[indexPath.row].msgText
        if (m_MsgList[indexPath.row].fileId != nil){
            cell.attach.isHidden = false
        }
        else{
            cell.attach.isHidden = true
        }
        
        
        return cell
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
    
    func GetMailMessages(){
        let parameters = ["userName" : Database.email]
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.MsgURL+"?userName=\(Database.email!)", method: .get, headers: headers)
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
                            self.m_MsgList = Mapper<MailMsg>().mapArray(JSONString: json!)
                            self.tableView.reloadData()
                        }
                    }
                    else{
                    }
                    
                }
        }
    }
    
    func deleteMessageRequest(indexpath : IndexPath){
        let msgObject = m_MsgList[indexpath.row]
        
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        var method : HTTPMethod!
        if (msgObject.fromUserName == Database.email){
            method = HTTPMethod.delete
            Alamofire.request(APIInterface.MsgURL + "/" + msgObject.idAsStr, method: method , headers: headers)
                .responseString{ response in
                    print("HttpURL Request:\(response.request)")
                    print("HttpURL Response:\(response.response)")
                    print("Server Data:\(response.result.value)")
                    SVProgressHUD.dismiss()
                    if (response.result.isSuccess){
                        let statusCode = response.response?.statusCode
                        if (statusCode! >= 200 && statusCode! < 300){
                            self.GetMailMessages()
                            self.tableView.reloadData()
                        }
                        else{
                            
                        }
                        
                    }
            }
            
        }
        else
        {
            method = HTTPMethod.put
            msgObject.recpientDeltedIt = true
            let parameters = msgObject.toJSON()
            Alamofire.request(APIInterface.MsgURL, method: method ,parameters : parameters,encoding : JSONEncoding.default, headers: headers)
                .responseString{ response in
                    print("HttpURL Request:\(response.request)")
                    print("HttpURL Response:\(response.response)")
                    print("Server Data:\(response.result.value)")
                    SVProgressHUD.dismiss()
                    if (response.result.isSuccess){
                        let statusCode = response.response?.statusCode
                        if (statusCode! >= 200 && statusCode! < 300){
                            self.GetMailMessages()
                            self.tableView.reloadData()
                        }
                        else{
                            
                        }
                        
                    }
            }
        }
        
        
        
    }
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: .titleAndImage)
        action.image = descriptor.image(forStyle: .backgroundColor, displayMode: .titleAndImage)
        action.backgroundColor = descriptor.color
    }
    func readMsgRequest(status : Bool, msgObject : MailMsg){
        let mailObj = msgObject
        mailObj.read = status
        let parameters = mailObj.toJSON()
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        Alamofire.request(APIInterface.MsgURL, method: .put ,parameters : parameters,encoding : JSONEncoding.default, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.GetMailMessages()
                        self.tableView.reloadData()
                    }
                    else{
                        
                    }
                    
                }
        }
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}
enum ButtonStyle {
    case backgroundColor, circular
}

enum ActionDescriptor {
    case read, unread
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .read: return "Read"
        case .unread: return "Unread"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .read: name = "Read"
        case .unread: name = "Unread"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .read, .unread: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        }
    }
}
extension MessageTableViewController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let msgObject = m_MsgList[indexPath.row]
        
        if orientation == .right{
            
            let delete = SwipeAction(style: .default, title: "Delete") { (action, indexpath) in
                self.deleteMessageRequest(indexpath: indexpath)
            }
            delete.backgroundColor = #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
            delete.hidesWhenSelected = true
            return [delete]
        }
        else{
            guard true else {
                return nil
            }
            let read = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                
                let updatedStatus = !msgObject.read
                
                self.readMsgRequest(status: updatedStatus, msgObject: msgObject)
                
                /*msgObject.read = updatedStatus
                
                let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
                
                cell.setUnread(readstatus: updatedStatus)*/
                
                
            }
            read.hidesWhenSelected = true
            let descriptor: ActionDescriptor!
            if msgObject.read == false
            {
                read.accessibilityLabel = "Mark as Read"
                descriptor = .read
            }
            else{
                read.accessibilityLabel = "Mark as Unread"
                descriptor = .unread
            }

            configure(action: read, with: descriptor)
            return [read]
        }
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.transitionStyle = .border
        return options
    }
}
