//
//  AlarmDetailCell.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/18.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmDetailCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
