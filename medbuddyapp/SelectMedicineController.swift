//
//  SelectMedicineController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/16/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka
class SelectMedicineController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        form
        +++ Section("Select Medicine")
            <<< PushRow<String>() {
                $0.title = "Medicine Selection"
                $0.options = ["A","B"]
                $0.value = "A"
                $0.selectorTitle = "Medicine List"
            }
        +++ Section("Time Detail")
            <<< DateInlineRow("fromDate"){
                    $0.title = $0.tag
                    $0.value  = Date()
                    $0.maximumDate = Date()
                }
                .onChange({row in
                    let toDate: DateInlineRow! = self.form.rowBy(tag: "toDate")
                    toDate.minimumDate = row.value
                })
            <<< DateInlineRow("toDate"){
                    $0.title = $0.tag
                    $0.value = Date()
                }
            <<< SwitchRow("switchtimesetting"){
                $0.title = "Is For Long Time"
                }
                .onChange{ [weak self] row in
                    let fromDate = self!.form.rowBy(tag: "fromDate")
                    let toDate = self!.form.rowBy(tag: "toDate")
                    
                    self?.form.rowBy(tag: "toDate")?.hidden = "$switchtimesetting == true"
                    
                    self?.form.rowBy(tag: "Relatedto")?.hidden = "$switchtimesetting == true"
                }
        +++ Section("Dosing")
            <<< IntRow(){
                $0.title = "Amount"
                $0.value = 100
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                $0.formatter = formatter
                }
            <<< ActionSheetRow<String>() {
                $0.title = "Weight Unit"
                $0.selectorTitle = "Select weight unit"
                $0.options = ["Mg", "Gram"]
                $0.value = "Mg"
                }
                .onPresent { from, to in
                    to.popoverPresentationController?.permittedArrowDirections = .up
                }
            <<< IntRow(){
                $0.title = "Times Per Day"
                $0.value = 100
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .decimal
                $0.formatter = formatter
                }
        +++ Section("Comment and Details")
            <<< TextAreaRow() {
                $0.placeholder = ""
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                }
        +++ Section()
            
            <<< ActionSheetRow<String>("Relatedto") {
                $0.title = "Related to"
                //$0.selectorTitle = "Related to"
                $0.options = ["SEVERE_SENSITIVITY",
                              "LIGHT_SENSITIVITY",
                              "WORKED",
                              "DIDNT_WORKED"]
                $0.value = "WORKED"
                }
                .onPresent { from, to in
                    to.popoverPresentationController?.permittedArrowDirections = .up
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
