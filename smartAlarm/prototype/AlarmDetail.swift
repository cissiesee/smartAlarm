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
    var sound: String
    
    init(repeatType: String, sound: String) {
        self.repeatType = repeatType
        self.sound = sound
        super.init()
    }
}
