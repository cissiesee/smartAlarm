//
//  AlarmDetail.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/2.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmDetail: NSObject {
    var isRepeat: Bool
    var sound: String
    
    init(isRepeat: Bool, sound: String) {
        self.isRepeat = isRepeat
        self.sound = sound
        super.init()
    }
}
