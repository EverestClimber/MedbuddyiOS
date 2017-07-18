//
//  CustomButtonArrayCell.swift
//  medbuddyapp
//
//  Created by Admin User on 4/22/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import Foundation
import Eureka
protocol PlayerCustomDelegate {
    func playRecord()
    func onCancel()
    func onSave()
}
public class PlayerCustomCell : Cell<String>, CellType{

    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var delegate : PlayerCustomDelegate!
    override public func setup() {
        super.setup()
        selectionStyle = .none
        playButton.setImage(UIImage(named: "PlayButton"), for: UIControlState())
    }
    
    @IBAction func onPlay(_ sender: Any) {
        delegate.playRecord()
    }
    override public func update() {
        super.update()
    }
    

    @IBAction func onCancel(_ sender: Any) {
        delegate.onCancel()
    }
    
    
    @IBAction func onSave(_ sender: Any) {
        delegate.onSave()
    }
    
}
public final class PlayerCustomCellRow: Row<PlayerCustomCell>, RowType{
    required public init(tag : String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<PlayerCustomCell>(nibName: "PlayerCustomCell")
    }
}
