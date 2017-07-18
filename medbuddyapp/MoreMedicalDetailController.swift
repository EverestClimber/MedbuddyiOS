//
//  MedicalDetailController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/14/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka
import CFAlertViewController
class MoreMedicalDetailController: FormViewController {

    
    var weightRow = IntRow() {
        $0.title = "Weight"
        $0.add(rule: RuleGreaterThan(min: 2))
        $0.add(rule: RuleSmallerThan(max: 999))
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
    
    var heightRow = IntRow() {
        $0.title = "Height"
        $0.add(rule: RuleGreaterThan(min: 2))
        $0.add(rule: RuleSmallerThan(max: 999))
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

    
    var medicationsArray : [ButtonRow] = []
    var diseaseArray : [ButtonRow] = []
    var attachmentArray : [ButtonRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        title = "More Medical Details"
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        
        
        
        form
            +++ Section(header: "Weight and Height", footer: "")
                <<< weightRow
                <<< heightRow
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder],
                               header: "Medications") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Medication"
                                        $0.presentationMode = .segueName(segueName: "MedicationDetailController", onDismiss:nil)
                                        
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return ButtonRow(){
                                        $0.title = "Tap to write medication"
                                        $0.presentationMode = .segueName(segueName: "SelectMedicineController", onDismiss: nil)
                                    }
                                }
                                
                                
                    }
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder],
                                   header: "Diseases") {
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Disease"
                                            $0.presentationMode = .segueName(segueName: "DiseaseDetailController", onDismiss: nil)
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return PushRow<String>{
                                            $0.title = "Tap to write disease"
                                            
                                            $0.presentationMode = .segueName(segueName: "SelectMedicineController", onDismiss: nil)
                                        }
                                    }
                                    
                    }
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder],
                                   header: "Attachments") {
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add attach file"
                                            
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return ButtonRow(){
                                            $0.title = "Tap to add attach file"

                                        }
                                        
                                    }
                    }
        
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MedicationDetailController")
        {
            let controller = segue.destination as! MedicationDetailController
            controller.delegate = self
        }
        if (segue.identifier == "DiseaseDetailController")
        {
            let controller = segue.destination as! DiseaseDetailController
            controller.delegate = self
        }
    }

}

extension MoreMedicalDetailController : MedicationDetailDelegate{
    func onMedicationDetailDone(){
        print("Medical Detail")
        
    }
}
extension MoreMedicalDetailController : DiseaseDetailDelegate {
    func onDiseaseDetailDone() {
        print("Disease Detail")
    }
}
