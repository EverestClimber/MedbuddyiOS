//
//  VisitProcessController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/22/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit

import Eureka
import Alamofire
import ObjectMapper
import SVProgressHUD
import AVFoundation
import ISMessages
import Speech
class VisitProcessController: FormViewController, FunctionButtonDelegate,PlayerCustomDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var attachfiles : [TextAreaRow]! = []
    
    var is_CreateMode : Bool!
    var currentVisitID : String!
    
    var medFileList : [MedFile]! = []
    
    var previewImage : UIImage!
    
    var audioRec: AVAudioRecorder?
    
    var recordedFileID : String!
    
    var scriptTextRow : TextAreaRow!
    
    var convTimer : Timer?
    
    var visitTitle : TextAreaRow! = TextAreaRow("title") {
        $0.placeholder = "Title"
        
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
    }
    var buttonArrayRow : CustomButtonArrayRow!
    var playerRow : PlayerCustomCellRow!
    var fileListSection : MultivaluedSection!
    enum SpeechStatus {
        case ready
        case recognizing
        case unavailable
    }
///////
    
    var timeTimer: Timer?
    var milliseconds: Int = 0
    
    var recorder: AVAudioRecorder! = nil
    var player: AVAudioPlayer? = nil
    var outputURL: URL!
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask? = nil
    var status = SpeechStatus.ready
    
    var script : String!
    var imagePicker =  UIImagePickerController()
    
//////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.contentInset.top = 50
        //tableView.allowsSelection = false
        ////////
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let outputPath = documentsPath.appendingPathComponent("\(UUID().uuidString).m4a")
        outputURL = URL(fileURLWithPath: outputPath)
        
        let settings = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32), AVSampleRateKey: NSNumber(value: 44100 as Int), AVNumberOfChannelsKey: NSNumber(value: 2 as Int)]
        try! recorder = AVAudioRecorder(url: outputURL, settings: settings)
        recorder.delegate = self
        recorder.prepareToRecord()
        
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
            break
        case .authorized:
            self.status = .ready
        case .denied, .restricted:
            self.status = .unavailable
        }

        ///////


        ///////
        visitTitle.value = ((self.tabBarController as! VisitTabController).childViewControllers[0] as! VisitBeforeController).visitTitle.value
        form
            +++ Section("Visit Title")
            <<< visitTitle
            .onChange({ (row) in
                ((self.tabBarController as! VisitTabController).childViewControllers[0] as! VisitBeforeController).visitTitle.value = row.value
                ((self.tabBarController as! VisitTabController).childViewControllers[1] as! VisitSummaryController).visitTitle.value = row.value
                
            })
            +++
            Section()
            <<< CustomButtonArrayRow("buttonArray"){
                $0.cell.height = {150}
                $0.cell.delegate = self
                
        }
            <<< PlayerCustomCellRow("playercustomRow"){
                $0.cell.height = {150}
                $0.cell.delegate = self
                $0.tag = "playercustomRow"
                $0.hidden = "$buttonArray == false"
            }
            +++ Section("Script")
            <<< TextAreaRow(){
                $0.placeholder = "Recording content"
                $0.tag = "scriptTextRow"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 200)
        }
            +++ MultivaluedSection(multivaluedOptions: [.Reorder,.Delete], header: "", footer: ""){
                $0.tag = "attachfile"
                }
 

        self.visitTitle = form.rowBy(tag: "title")
        self.scriptTextRow = form.rowBy(tag: "scriptTextRow")
        self.buttonArrayRow = form.rowBy(tag: "buttonArray")
        self.playerRow = form.rowBy(tag: "playercustomRow")
        self.fileListSection = form.sectionBy(tag: "attachfile") as! MultivaluedSection!
        getVisitProcessDetail()
 
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        //self.tabBarController?.navigationItem.rightBarButtonItems = []
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            NSLog("Error: \(error)")
        }

        NotificationCenter.default.addObserver(self, selector: #selector(stopRecording(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    
    func getVisitProcessDetail(){
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
        
        attachfiles.removeAll()
        fileListSection.removeAll()
        for medFile : MedFile in medFileList{
            attachfiles.append(TextAreaRow(){
                $0.value = medFile.title
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                
            })
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
        
        fileListSection.reload()
        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imagecontroller = segue.destination as! ImagePreviewController
        imagecontroller.image = previewImage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func camera() {
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.buttonArrayRow.cell.cameraButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        })
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    func attach() {
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.buttonArrayRow.cell.attachButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        })
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if picker.sourceType == .camera{
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.buttonArrayRow.cell.cameraButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        if picker.sourceType == .photoLibrary{
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.buttonArrayRow.cell.attachButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .camera{
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.buttonArrayRow.cell.cameraButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            postMultipartformImageData(image: image, visitId: currentVisitID, is_ocr: true, is_content: true, is_speech: false)
            
        }
        if picker.sourceType == .photoLibrary{
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.buttonArrayRow.cell.attachButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            postMultipartformImageData(image: image, visitId: currentVisitID, is_ocr: true, is_content: true, is_speech: false)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?, script : String?)
    {
        // do something with fileURL
        if fileURL == nil{
            scriptTextRow.value = ""
        }
        else{
            postMultipartformData(fileURL: fileURL!, visitId: currentVisitID, is_ocr: false,is_content: true,is_speech: true)
            
        }
        self.buttonArrayRow.value = false
        tableView.reloadData()
    }
    
    func postMultipartformData(fileURL : URL,visitId : String, is_ocr : Bool,is_content : Bool,is_speech : Bool){
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        _ = ["visitId" : visitId, "is_ocr": is_ocr, "is_content":is_content,"is_speech":is_speech] as [String : Any]
        
        let URLStr = APIInterface.FileURL + "?visitId=\(visitId)" + "&is_ocr=\(is_ocr)" + "&is_content=\(is_content)" + "&is_speech=\(is_speech)"
        
        SVProgressHUD.show()
        var data : Data!
        do{
            data = try Data(contentsOf: fileURL)
        }
        catch{
            
        }
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            multipartFormData.append(data, withName: "file", fileName: fileURL.lastPathComponent, mimeType: "application/octet-stream")
            multipartFormData.append(fileURL.lastPathComponent.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "fileTitle")
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: URLStr, method: .post, headers: headers, encodingCompletion: {
            encodingResult in
            
            SVProgressHUD.dismiss()
            switch(encodingResult){
                
            case .success(let upload,_,_):
                upload.responseString{
                    response in
                    print(response)
                    self.recordedFileID = response.value
                    self.getVisitProcessDetail()
                    //self.convTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.ConverstationContentProcess), userInfo: nil, repeats: true)
                    print("success")
                }
                
                break
                
            case .failure(let error):
                print(error)
                break
            }
        })
        
        
    }
    
    func ConverstationContentProcess(){
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        let parameters = ["userName" : Database.email, "visitId" : currentVisitID, "fildId" : recordedFileID ]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.ConversationURL + "?userName=\(Database.email!)&visitId=\(currentVisitID!)&fileId=\(recordedFileID!)", method: .get, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        let conv_Content = Mapper<ConversationContent>().map(JSONString: response.result.value!)
                        print("")
                        if conv_Content?.fileStatus == "FINISHED_OK" || conv_Content?.fileStatus == "FINISHED_ERR"{
                            self.convTimer?.invalidate()
                            self.convTimer = nil
                            self.scriptTextRow.value = conv_Content?.rawTranscript
                        }
                    }
                    else{
                    }
                    
                }
        }

    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
                            self.performSegue(withIdentifier: "previewimage", sender: nil)
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
            /*.responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        //let data = Data(base64Encoded: response.result.value!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                        if (type == true){
                            let data = Data(base64Encoded: response.result.value!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                            let image = UIImage(data: data!)
                            self.previewImage = image
                            self.performSegue(withIdentifier: "previewimage", sender: nil)
                        }
                        else{
                            let data = response.result.value?.data(using: String.Encoding.utf8)
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
        }*/
        
    }
    func postMultipartformImageData(image : UIImage,visitId : String, is_ocr : Bool,is_content : Bool,is_speech : Bool){
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        let parameters = ["visitId" : visitId, "is_ocr": is_ocr, "is_content":is_content,"is_speech":is_speech] as [String : Any]
        
        var URLStr = APIInterface.FileURL + "?visitId=\(visitId)" + "&is_ocr=\(is_ocr)" + "&is_content=\(is_content)" + "&is_speech=\(is_speech)"
        
        SVProgressHUD.show()
        let img = resizeImage(image: image, targetSize: CGSize(width: 200, height: 200 ))
        let imageData = UIImagePNGRepresentation(img)
        
        
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
                multipartFormData.append((imageData?.base64EncodedData())!, withName: "file", fileName: "\(self.medFileList.count).png", mimeType: "image/png")
                multipartFormData.append("\(self.medFileList.count).png".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "fileTitle")
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: URLStr, method: .post, headers: headers, encodingCompletion: {
            encodingResult in
            SVProgressHUD.dismiss()
            switch(encodingResult){
                
            case .success(let upload,_,_):
                
                self.getVisitProcessDetail()
                print("success")
                break
                
            case .failure(let error):
                print(error)
                break
            }
        })
        
    }
    
    func onSave() {
        cleanup()
        audioRecorderViewControllerDismissed(withFileURL: outputURL, script : self.script)
    }
    func onCancel() {
        cleanup()
        audioRecorderViewControllerDismissed(withFileURL: nil, script: "")
    }
    func playRecord() {
        if let player = player {
            player.stop()
            self.player = nil
            updateControls()
            return
        }
        
        do {
            try player = AVAudioPlayer(contentsOf: outputURL)
        }
        catch let error as NSError {
            NSLog("error: \(error)")
        }
        
        player?.delegate = self
        player?.play()
        
        updateControls()

    }
    func record() {
        print("Record Controller")
        
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
                ISMessages.showCardAlert(withTitle: "Allowed", message: "Microphone is allowed", duration: 2, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.success, alertPosition:ISAlertPosition.top, didHide: nil)
                self.timeTimer?.invalidate()
                
                
                self.toggleRecord()
                
            } else {
                // User denied microphone. Tell them off!
                ISMessages.showCardAlert(withTitle: "Alert", message: "Microphone is denied", duration: 2, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition:ISAlertPosition.top, didHide: nil)
                
            }
        }
    }
    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.status = .ready
                default:
                    self.status = .unavailable
                }
            }
        }
    }
    func startRecording() {
        // Setup audio engine and speech recognizer
        guard let node = audioEngine.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.status = .recognizing
        } catch {
            return print(error)
        }
        
        // Analyze the speech
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.script = result.bestTranscription.formattedString;
                self.scriptTextRow.value = self.script
                
                self.tableView.reloadData()
            } else if let error = error {
                print(error)
            }
        })
    }
    
    /// Stops and cancels the speech recognition.
    func cancelRecording() {
        audioEngine.stop()
        if let node = audioEngine.inputNode {
            node.removeTap(onBus: 0)
        }
        recognitionTask?.cancel()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func toggleRecord() {
        
        timeTimer?.invalidate()
        
        if recorder.isRecording {
            recorder.stop()
            self.cancelRecording()
            self.status = .ready
        } else {
            self.milliseconds = 0
            
            self.playerRow.cell.timeLabel.text = "00:00.00"
            self.timeTimer = Timer.scheduledTimer(timeInterval: 0.0167, target: self, selector: #selector(self.updateTimeLabel(_:)), userInfo: nil, repeats: true)
            recorder.deleteRecording()
            recorder.record()
            
            
            self.startRecording()
            self.status = .recognizing
        }
        
        updateControls()
        
    }
    
    func stopRecording(_ sender: AnyObject) {
        if recorder.isRecording {
            toggleRecord()
        }
    }
    
    func cleanup() {
        timeTimer?.invalidate()
        if recorder.isRecording {
            recorder.stop()
            recorder.deleteRecording()
        }
        if let player = player {
            player.stop()
            self.player = nil
        }
    }
    
 
    
    
    func updateControls() {
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.buttonArrayRow.cell.recordButton.transform = self.recorder.isRecording ? CGAffineTransform(scaleX: 0.5, y: 0.5) : CGAffineTransform(scaleX: 1, y: 1)
        })
        
        if let _ = player {
            self.playerRow.cell.playButton.setImage(UIImage(named: "StopButton"), for: UIControlState())
            self.buttonArrayRow.cell.recordButton.isEnabled = false
            self.buttonArrayRow.cell.attachButton.isEnabled = false
            self.buttonArrayRow.cell.cameraButton.isEnabled = false
        } else {
            self.playerRow.cell.playButton.setImage(UIImage(named: "PlayButton"), for: UIControlState())
            self.buttonArrayRow.cell.recordButton.isEnabled = true
            self.buttonArrayRow.cell.attachButton.isEnabled = true
            self.buttonArrayRow.cell.cameraButton.isEnabled = true
        }
        
        self.playerRow.cell.playButton.isEnabled = !recorder.isRecording
        self.buttonArrayRow.cell.attachButton.isEnabled = !recorder.isRecording
        self.buttonArrayRow.cell.cameraButton.isEnabled = !recorder.isRecording
        
        self.playerRow.cell.playButton.alpha = recorder.isRecording ? 0.25 : 1
        self.playerRow.cell.saveButton.isEnabled = !recorder.isRecording
        self.playerRow.cell.cancelButton.isEnabled = !recorder.isRecording
    }
    
    
    
    
    // MARK: Time Label
    
    func updateTimeLabel(_ timer: Timer) {
        milliseconds += 1
        let milli = (milliseconds % 60) + 39
        let sec = (milliseconds / 60) % 60
        let min = milliseconds / 3600
        self.playerRow.cell.timeLabel.text = NSString(format: "%02d:%02d.%02d", min, sec, milli) as String
    }
    
    
    // MARK: Playback Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        updateControls()
    }
    
    public override func onDeleteProcess(indexPath : IndexPath) {
        
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.FileURL + "/\(self.medFileList[indexPath.row].idAsStr!)", method: .delete, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                SVProgressHUD.dismiss()
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        //super.onDeleteProcess(indexPath: indexPath)
                        self.fileListSection.remove(at: indexPath.row)
                        self.getVisitProcessDetail()
                        
                        
                    }
                    else{
                    }
                    
                }
        }
        
        
        
    }
}
