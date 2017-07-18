//
//  CustomButtonArrayCell.swift
//  medbuddyapp
//
//  Created by Admin User on 4/22/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import Eureka
protocol FunctionButtonDelegate {
    func record()
    func camera()
    func attach()
}
public class CustomButtonArrayCell : Cell<Bool>, CellType{
    
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var delegate : FunctionButtonDelegate!
    
    override public func setup() {
        super.setup()
        selectionStyle = .none
        attachButton.layer.cornerRadius = 40
        cameraButton.layer.cornerRadius = 40
        recordButton.layer.cornerRadius = 50
        row.value = false
    }
    
    @IBAction func onCamera(_ sender: Any) {
        print("Camera")
        delegate.camera()
    }

    @IBAction func onRecord(_ sender: Any) {
        print("Record")
        
        if (row.value == false){
            row.value = true
        }
        else{
            //row.value = false
        }
        delegate.record()
    }

    @IBAction func onAttach(_ sender: Any) {
        print("Attach")
        delegate.attach()
    }

    override public func update() {
        super.update()
    }
    
}
public final class CustomButtonArrayRow: Row<CustomButtonArrayCell>, RowType {

    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CustomButtonArrayCell>(nibName: "ButtonArrayCustomCell")
    }
}
