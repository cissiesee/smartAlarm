//
//  Alarm.swift
//  smartAlarm
//
//  Created by linkage on 2018/4/28.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class Alarm: NSObject {
    var id: String
    var type: String
    var subType: String
    var time: String
    var info: String
    var isOn: Bool
    var sound: String
    var importantInfo: AlarmImportantInfo
    var repeatInfo: AlarmRepeatInfo
    
    init(id: String, type: String, subType: String, time: String, info: String, isOn: Bool, sound: String, importantInfo: AlarmImportantInfo, repeatInfo: AlarmRepeatInfo) {
        self.id = id
        self.type = type
        self.subType = subType
        self.time = time
        self.info = info
        self.isOn = isOn
        self.sound = sound
        self.importantInfo = importantInfo
        self.repeatInfo = repeatInfo
        super.init()
    }
}
