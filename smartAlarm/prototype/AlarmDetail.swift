//
//  AlarmDetail.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/2.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmDetail: NSObject {
    var repeatType: String
    var repeatInfo: String
    var sound: String
    var weekday: String
    var day: String
    var month: String
    
    init(repeatType: String, repeatInfo: String, weekday: String, day: String, month: String, sound: String) {
        self.repeatType = repeatType
        self.repeatInfo = repeatInfo
        self.sound = sound
        self.weekday = weekday
        self.day = day
        self.month = month
        super.init()
    }
}
