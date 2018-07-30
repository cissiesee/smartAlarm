//
//  Utils.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/13.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation

class DateUtils {
//    static func sysWeekdayToWeekday(sysWeekday: int) -> int {
//        return (sysWeekday - 2) < 0 ? 6 : (sysWeekday - 2)
//    }
//
//    static func weekdayToSysWeekday(weekday: int) -> int {
//        return (weekday + 2) < 0 ? 6 : (sysWeekday - 2)
//    }
    
    static func getWeekdayList() -> [String] {
        return ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    }
    
    static func getMonthdayList() -> [String] {
        var arr: [String] = []
        for i in 1...31 {
            arr.append("\(i)日")
        }
        return arr
    }
    
    static func formatWeekday(date: Date) -> String {
        let dateDetail = Calendar.current.dateComponents([.weekday], from: date)
        return getWeekdayFromSysWeekday(sysWeekday: dateDetail.weekday!)
    }
    
    static func getWeekdayFromSysWeekday(sysWeekday: Int) -> String {
        let weekdayList = getWeekdayList()
        return weekdayList[(sysWeekday - 2) < 0 ? 6 : (sysWeekday - 2)]
    }
    
    static func getMonthDayFromSysMonthDay(sysMonthDay: Int) -> String {
        let monthDayList = getMonthdayList()
        return monthDayList[sysMonthDay - 1]
    }
    
    static func getSysMonthDayFromMonthDay(monthDay: String) -> Int {
        let monthDayList = getMonthdayList()
        let index = monthDayList.index(of: monthDay)!
        return index + 1
    }
    
    static func getSysWeekdayFromWeekday(weekday: String) -> Int {
        let weekdayList = getWeekdayList()
        let index = weekdayList.index(of: weekday)!
        return index + 2 > 7 ? 1 : index + 2
    }
    
    static func getDateFromWeekday() {
        
    }
    
    static func formatMonthday(date: Date) -> String {
        let dateDetail = Calendar.current.dateComponents([.day], from: date)
        let monthdayList = getMonthdayList()
        return monthdayList[dateDetail.day! - 1]
    }
    
    static func getDateFromMonthday() {
        
    }
    
    static func formatDate(date: Date, formatStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStr
        let datestr = dateFormatter.string(from: date)
        return datestr
    }
    
    static func getDateFromFormat(dateStr: String, formatStr: String) -> Date {
        let dformatter = DateFormatter()
        dformatter.dateFormat = formatStr
        let date = dformatter.date(from: dateStr)
        print("getDateFromFormat:", date as Any)
        return date!
    }
    
    static func getDateComponentsFromAlarm(alarm: Alarm) -> DateComponents {
        let times = alarm.time.split(separator: ":")
        var selectDateComponents = DateComponents()
        
        selectDateComponents.hour = Int(times[0])
        selectDateComponents.minute = Int(times[1])
        if alarm.details.weekday != "" {
            selectDateComponents.weekday = Int(alarm.details.weekday)
        }
        if alarm.details.day != "" {
            selectDateComponents.day = Int(alarm.details.day)
        }
        if alarm.details.month != "" {
            selectDateComponents.month = Int(alarm.details.month)
        }
        return selectDateComponents
    }
}
