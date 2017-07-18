//
//  MedicineInstanceExtraData.swift
//  medbuddyapp
//
//  Created by Admin User on 4/11/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
class MedicineInstanceExtraData : InstanceExtraData {
    var _doseing : MedicationDosing!
    var result : EMedicineResult!
    func getDoseing() -> MedicationDosing {
        
        return _doseing;
    }
    func getResult() -> EMedicineResult{
        return result;
    }
    
    func setResult(result : EMedicineResult) {
        self.result = result;
    }
    
    func setDosing(p_dosing : MedicationDosing){
        self._doseing = p_dosing;
    }
    
    override init() {
        
    }
    init(p_doseing : MedicationDosing){
        super.init()
        self._doseing = p_doseing
    }
    
    
    
    
}
