//
//  AlarmSoundCell.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/18.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmSoundCell: UITableViewCell {
    @IBOutlet weak var soundType: UILabel!
    @IBOutlet weak var soundContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
