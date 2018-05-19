//
//  Alarm.swift
//  smartAlarm
//
//  Created by linkage on 2018/4/28.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class Alarm: NSObject {
    var createTime: String
    var time: String
    var info: String
    var isOn: Bool
    var details: AlarmDetail
    
    init(createTime: String, time: String, info: String, isOn: Bool, details: AlarmDetail) {
        self.createTime = createTime
        self.time = time
        self.info = info
        self.isOn = isOn
        self.details = details
        super.init()
    }
}
