//
//  MedicationDetailController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/14/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka

protocol MedicationDetailDelegate {
    func onMedicationDetailDone()
}
class MedicationDetailController: FormViewController {
    var delegate : MedicationDetailDelegate!
    var DrugDetail = NameRow() {
        $0.placeholder = "eg : Nitroglycerin Sublingual"
    }
    var Synopsis = TextAreaRow() {
        $0.placeholder = ""
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
    }
    var SideEffects = TextAreaRow() {
        $0.placeholder = ""
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
    }
    var Dosing = TextAreaRow() {
        $0.placeholder = ""
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
    }
    var Warnings = TextAreaRow() {
        $0.placeholder = ""
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
    }
    var Url = URLRow(){
        $0.title = "URL"
        $0.validationOptions = .validatesOnChange
        $0.add(rule: RuleURL())
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        .onRowValidationChanged { cell, row in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                row.section?.remove(at: rowIndex + 1)
            }
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    let labelRow = LabelRow() {
                        $0.title = validationMsg
                        $0.cell.height = { 30 }
                    }
                    row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                }
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(submitAction(_:)))
        //let moreBtn = UIBarButtonItem(title: "More>", style: .plain, target: self, action: #selector(moreAction(_:)))
        self.navigationItem.rightBarButtonItems = [/*moreBtn,*/doneBtn]
        
        form
            +++ Section("Drug Details")
            <<< DrugDetail
            +++ Section("Synopsis")
            <<< Synopsis
            +++ Section("Side Effects")
            <<< SideEffects
            +++ Section("Dosing")
            <<< Dosing
            +++ Section("Warnings")
            <<< Warnings
            +++ Section("Fur further reading")
            <<< Url
        
    }
    func submitAction(_ sender: AnyObject?) {
        let error = form.validate()
        if (error.isEmpty)
        {
            
            delegate.onMedicationDetailDone()
            navigationController?.popViewController(animated: true)
            
        }
        else
        {
            
        }
    }
}
