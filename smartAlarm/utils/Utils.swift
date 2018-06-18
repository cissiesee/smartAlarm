//
//  Utils.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/13.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation

class Utils {
    static func CaculateWeekDay(dateStr:String) -> String {
        let dateArr = dateStr.components(separatedBy: "-")
        if dateArr.count == 3 {
            var y = Int(dateArr[0])!
            var m = Int(dateArr[1])!
            let d = Int(dateArr[2])!
            if m == 1 || m == 2 {
                m += 12
                y -= 1
            }
            let iWeek = (d + 2 * m + 3 * ( m + 1 ) / 5 + y + y / 4 - y / 100 + y / 400) % 7
            switch iWeek {
            case 0: return "星期一"
            case 1: return "星期二"
            case 2: return "星期三"
            case 3: return "星期四"
            case 4: return "星期五"
            case 5: return "星期六"
            case 6: return "星期天"
            default:
                return ""
            }
        } else {
            return "星期未知"
        }
    }
}
