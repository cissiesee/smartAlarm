//
//  RecordManager.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/16.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation
import AVFoundation

class AlarmUtils {
    static func getAlarmLabelByType(type: String) -> String {
        if type == "" {
            return "普通"
        } else {
            let alarmTargetIndex = ALARM_TYPES.index( where: {item -> Bool in
                return item["type"] as! String == type
            })
            return ALARM_TYPES[alarmTargetIndex!]["label"] as! String
        }
    }
    
    static func getAlarmLabelBySubType(type: String, subType: String) -> String {
        let alarmTargetIndex = ALARM_TYPES.index( where: {item -> Bool in
            return item["type"] as! String == type
        })
        let subAlarmTypes = ALARM_TYPES[alarmTargetIndex!]["subTypes"] as! [Dictionary<String, Any>]
        let alarmSubTargetIndex = subAlarmTypes.index( where: {item -> Bool in
            return item["type"] as! String == subType
        })
        return subAlarmTypes[alarmSubTargetIndex!]["label"] as! String
    }
    
    static func getAlarmTypeByLabel(label: String) -> String {
        let alarmTargetIndex = ALARM_TYPES.index( where: {item -> Bool in
            return item["label"] as! String == label
        })
        return ALARM_TYPES[alarmTargetIndex!]["type"] as! String
    }
    
    static func getAlarmTypeBySubLabel(label: String, subLabel: String) -> String {
        let alarmTargetIndex = ALARM_TYPES.index( where: {item -> Bool in
            return item["label"] as! String == label
        })
        let subAlarmTypes = ALARM_TYPES[alarmTargetIndex!]["subType"] as! [Dictionary<String, Any>]
        let alarmSubTargetIndex = subAlarmTypes.index( where: {item -> Bool in
            return item["label"] as! String == subLabel
        })
        return subAlarmTypes[alarmSubTargetIndex!]["label"] as! String
    }
}
