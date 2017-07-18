//
//  ViewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/3/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit

import SVProgressHUD
import Alamofire
import CFAlertViewController
import ACFloatingTextfield_Objc
import DTTextField
class ViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var m_emailText: DTTextField!
    
    @IBOutlet weak var m_passwordText: DTTextField!
    
    @IBOutlet weak var m_signinBtn: UIButton!
    
    @IBOutlet weak var m_createaccount: UIButton!
    @IBOutlet weak var m_forgotPassword: UIButton!

    
    @IBAction func onlogin(_ sender: Any) {
        if (!isValidEmail(testStr: m_emailText.text!)){
            
        }
            
        else{
            SVProgressHUD.show()
            
            let userName : String = /*"adimeiman_2@gmail.com"*/ m_emailText.text!
            let password : String = /*"muki1234!"*/ m_passwordText.text!
            
            let Parameters = ["username" : userName,"password" : password]
            
            Alamofire.request(APIInterface.AuthenticationURL, method: .post, parameters: Parameters, encoding: URLEncoding.httpBody, headers: nil)
                .responseString{ response in
                    SVProgressHUD.dismiss()
                    print("HttpURL Request:\(response.request)")  // original URL request
                    print("HttpURL Response:\(response.response)") // HTTP URL response
                    print("Server Data:\(response.result.value)")     // Token data
                    
                    if (response.result.isSuccess){
                        let statusCode = response.response?.statusCode
                        if (statusCode! >= 200 && statusCode! < 300){
                            Database.token = response.result.value
                            Database.email = self.m_emailText.text
                            
                            let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Login Status", message: "Successed", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                            alertControler.addAction(CFAlertAction.action(title: "Go to VisitListScreen", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: { (action) in
                                self.performtoVisitListScreen()
                            }))
                            
                            self.present(alertControler, animated: true, completion: nil)
                            
                            
                            
                            
                            
                        }
                        if (statusCode == 406){
                            
                            let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Login Status", message: Resource.Login_406, textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                            alertControler.addAction(CFAlertAction.action(title: "Go to Replace Password Screen", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: { (action) in
                                self.performtoReplaceScreen()
                            }))
                            
                            self.present(alertControler, animated: true, completion: nil)
                            
                            
                        }
                        if (statusCode == 401){
                            let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Login Status", message: Resource.Login_401, textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                            alertControler.addAction(CFAlertAction.action(title: "Please Write correct email and password", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: nil))
                            self.present(alertControler, animated: true, completion: nil)
                        }
                    }
            }
        }
    }
    

    @IBAction func onforgotpassword(_ sender: Any) {
        let Parameters = ["username" : m_emailText.text]
        SVProgressHUD.show()
        Alamofire.request(APIInterface.AuthenticationURL, method: .post, parameters: Parameters, encoding: URLEncoding.httpBody, headers: nil)
            .responseString{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                print("Data:\(response)")
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        
                        
                        let alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Did you forget password?", message: Resource.Login_ForgotLink, textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                        alertControler.addAction(CFAlertAction.action(title: "Go to Replace Password Screen", style: .Default, alignment: .justified, backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)), textColor: UIColor.white, handler: {action in self.performtoReplaceScreen()}))
                        
                        self.present(alertControler, animated: true, completion: nil)
                        
                    }
                    else{
                    }
                    
                }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    func performtoVisitListScreen(){
        (UIApplication.shared.delegate as! AppDelegate).setupCustomWindow()
        //performSegue(withIdentifier: "onsigninidentifier", sender: self)
        
        
        
    }
    func performtoReplaceScreen(){
        performSegue(withIdentifier: "logintoreplacepassword", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.isHidden = true
        m_emailText.delegate = self
        m_passwordText.delegate = self
        
        m_emailText.textColor = UIColor.white
        m_passwordText.textColor = UIColor.white
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
}

