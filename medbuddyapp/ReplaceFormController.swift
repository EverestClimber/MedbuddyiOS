//
//  ReplaceFormController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/12/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import SwiftyFORM

import Alamofire
import SVProgressHUD
import CFAlertViewController
class ReplaceFormController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    override func loadView() {
        super.loadView()
        //form_installSubmitButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitAction(_:)))
    }

    func submitAction(_ sender: AnyObject?) {
        formBuilder.validateAndUpdateUI()
        let result = formBuilder.validate()
        
        
        if (password.value != Database.password){
            form_simpleAlert("Validation Error", Resource.ReplacePassword_Val5 )
        }
        else
        {
            if (newpassword.value != repeatpassword.value){
                form_simpleAlert("Validation Error", Resource.ReplacePassword_Val6)
            }
            else
            {
                self.showSubmitResult(result)
            }
        }
        
        
    }
    
    func showSubmitResult(_ result: FormBuilder.FormValidateResult) {
        switch result {
        case .valid:
            putReuqest()
        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "Invalid"
            form_simpleAlert(title, message)
        }
    }
    func putReuqest(){
        SVProgressHUD.show()
        let paramerters = ["idAsStr" : "", "userName" : email.value, "password" : newpassword.value, "isTempPass" : false] as [String : Any]
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer " + Database.token!]
        /*
         {"idAsStr":”previous id”, "userName":"myuser@gmail.com", "password":”new password” ,"isTempPass":false}
         Content-Type:application/json;charset=UTF-8
         •	Authorization;Bearer token */
        Alamofire.request(APIInterface.AuthenticationURL + "/" + email.value, method: .put , parameters: paramerters, encoding: URLEncoding.httpBody, headers: headers)
            .responseString{ response in
                SVProgressHUD.dismiss()
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                    
                        
                        var alertControler : CFAlertViewController = CFAlertViewController.alertController(title: "Replace Password Success", message: Resource.Login_ForgotLink, textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "Replace Password"
        builder.toolbarMode = .simple
        builder += SectionHeaderTitleFormItem().title("Former Details")
        builder += email
        builder += password
        builder += SectionHeaderTitleFormItem().title("New Password Setting")
        builder += newpassword
        builder += repeatpassword

        builder.alignLeft([email, password, newpassword, repeatpassword])
    }
    var newpassword: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("New Password").password().placeholder("required")
        instance.keyboardType = .default
        instance.autocorrectionType = .no
        instance.softValidate(CountSpecification.between(6,20), message: Resource.ReplacePassword_Val1)
        instance.submitValidate(NotSpecification.init(OrSpecification.init(CharacterSetSpecification.alphanumericCharacterSet(), CharacterSetSpecification.symbolCharacterSet())), message: Resource.ReplacePassword_Val2)
        return instance
    }()
    
    var repeatpassword: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Repeat Password").password().placeholder("required")
        instance.keyboardType = .default
        instance.autocorrectionType = .no
        instance.softValidate(CountSpecification.between(6,20), message: Resource.ReplacePassword_Val1)
        instance.submitValidate(NotSpecification.init(OrSpecification.init(CharacterSetSpecification.alphanumericCharacterSet(), CharacterSetSpecification.symbolCharacterSet())), message: "")
        
        
        return instance
    }()
    
    
    var password: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Previous Password").password().placeholder("required")
        instance.keyboardType = .default
        instance.autocorrectionType = .no
        instance.softValidate(CountSpecification.between(6,20), message: Resource.ReplacePassword_Val1)
        instance.submitValidate(NotSpecification.init(OrSpecification.init(CharacterSetSpecification.alphanumericCharacterSet(), CharacterSetSpecification.symbolCharacterSet())), message: Resource.ReplacePassword_Val2)
        return instance
    }()
    
    var email: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Email").placeholder("required")
        instance.keyboardType = .emailAddress
        instance.softValidate(NotSpecification.init(CountSpecification.exactly(0)), message: Resource.ReplacePassword_Val3)
        instance.softValidate(EmailSpecification(), message: Resource.ReplacePassword_Val4)
        return instance
    }()
}

