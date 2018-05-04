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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func handleSwitch() {
        if (enableSwitch.isOn) {
            timeLabel.textColor = UIColor.black
            infoLabel.textColor = UIColor.black
        } else {
            timeLabel.textColor = UIColor.lightGray
            infoLabel.textColor = UIColor.lightGray
        }
    }
    
}
