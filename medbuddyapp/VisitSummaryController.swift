//
//  VisitSummaryController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/28/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Eureka
import Alamofire
import ObjectMapper
import AVFoundation
import MIBadgeButton_Swift
class VisitSummaryController: FormViewController,AVAudioPlayerDelegate {
    var fileListSection : MultivaluedSection!
    var medFileList : [MedFile]! = []
    var currentVisitID : String!
    var previewImage : UIImage!
    var player: AVAudioPlayer? = nil
    var bellNotification : UIBarButtonItem!
    var visitTitle : TextAreaRow! = TextAreaRow("title") {
        $0.placeholder = "Title"
        
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        
        tableView.contentInset.top = 50
        
        visitTitle.value = ((self.tabBarController as! VisitTabController).childViewControllers[0] as! VisitBeforeController).visitTitle.value

        form
            +++ Section("Visit Title")
            <<< visitTitle
                .onChange({ (row) in
                    ((self.tabBarController as! VisitTabController).childViewControllers[0] as! VisitBeforeController).visitTitle.value = row.value
                    ((self.tabBarController as! VisitTabController).childViewControllers[0] as! VisitProcessController).visitTitle.value = row.value
                })
            +++
            Section()
            <<< LabelRow(){
                $0.title = "Dr Name"
                $0.tag = "DrName"
        }
            <<< LabelRow(){
                $0.title = "Date"
                $0.tag = "Date"
        }
            +++ Section("Visit Content")
            <<< TextAreaRow(){
                $0.title = "Visit Content"
        }
            +++ MultivaluedSection(multivaluedOptions: [.Reorder,.Delete], header: "", footer: ""){
                $0.tag = "attachfile"
        }
        
        self.fileListSection = form.sectionBy(tag: "attachfile") as! MultivaluedSection!
            
        
        getVisitDetail()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let btn2 = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn2.setImage(UIImage(named: "bell"), for: .normal)
        //numOfActiveAlerts + numOfExpiredReminders
        
        btn2.badgeEdgeInsets = UIEdgeInsetsMake(10, 10, 0, 15)
        btn2.badgeTextColor = UIColor.white
        
        btn2.badgeBackgroundColor = UIColor.red
        bellNotification = UIBarButtonItem(customView: btn2)
        self.tabBarController?.navigationItem.rightBarButtonItem = bellNotification*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getVisitDetail(){
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        let parameters = ["userName" : Database.email!, "visitId" : currentVisitID!]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.FileURL, method: .get, parameters: parameters, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        self.medFileList = Mapper<MedFile>().mapArray(JSONString: response.result.value!)
                        self.setField()
                    }
                    else{
                    }
                    
                }
        }
        
    }
    func setField(){
        
        fileListSection.removeAll()
        for medFile : MedFile in medFileList{
            fileListSection.append(ButtonRow(){ (row: ButtonRow) -> Void in
                row.title = medFile.title
                }.onCellSelection({ (cell, row) in
                    print(1)
                    if medFile.forSpeech == false{
                        self.preview(row: (row.indexPath?.row)!, type : true)
                    }
                    else{
                        self.preview(row: (row.indexPath?.row)!, type : false)
                    }
                }))
            
            
        }
        
        
        tableView.reloadData()
    }
    func preview(row : Int,type : Bool){
        print(row)
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.FileURL + "/\(self.medFileList[row].idAsStr!)", method: .get, headers: headers)
            .responseData{
                response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        if (type == true){
                            
                            let image = UIImage(data: Data(base64Encoded: response.result.value!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!)
                            self.previewImage = image 
                            self.performSegue(withIdentifier: "previewimagesummary", sender: nil)
                        }
                        else{
                            let data = response.result.value
                            do {
                                try self.player = AVAudioPlayer(data: data!)
                            }
                            catch let error as NSError {
                                NSLog("error: \(error)")
                            }
                            
                            self.player?.delegate = self
                            self.player?.play()
                            
                        }
                    }
                    else{
                    }
                    
                }
        }
        
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil

    }
}
