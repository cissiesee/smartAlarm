//
//  AlarmImportantInfo.swift
//  smartAlarm
//
//  Created by linkage on 2018/8/5.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation

class AlarmImportantInfo: NSObject {
    var level: Int
    var repeatTimes: Int
    var repeatInterval: Int
    
    init(level: Int, repeatTimes: Int, repeatInterval: Int) {
        self.level = level
        self.repeatTimes = repeatTimes
        self.repeatInterval = repeatInterval
        super.init()
    }
}
