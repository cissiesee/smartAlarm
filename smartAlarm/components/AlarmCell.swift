//
//  AlarmCell.swift
//  smartAlarm
//
//  Created by linkage on 2018/4/28.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    var alarmId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeColor()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func changeColor() {
        if (enableSwitch.isOn) {
            timeLabel.textColor = UIColor.black
            //            infoLabel.textColor = UIColor.black
        } else {
            timeLabel.textColor = UIColor.lightGray
            //            infoLabel.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func handleSwitch() {
        changeColor()
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "AlarmSwitchNotification"), object: ["id": alarmId, "isOn": enableSwitch.isOn])
    }
    
}
