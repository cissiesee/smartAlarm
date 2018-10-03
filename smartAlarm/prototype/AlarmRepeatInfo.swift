//
//  AlarmDetail.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/2.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmRepeatInfo: NSObject {
    var repeatType: Int
    var repeatInfo: String
    var weekday: Int?
    var day: Int?
    var month: Int?
    
    init(repeatType: Int, repeatInfo: String, weekday: Int?, day: Int?, month: Int?) {
        self.repeatType = repeatType
        self.repeatInfo = repeatInfo
        self.weekday = weekday
        self.day = day
        self.month = month
        super.init()
    }
}
