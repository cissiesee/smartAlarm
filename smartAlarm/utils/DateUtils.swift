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
    
    static func getYearDateFromDateCompnents(month: Int, day: Int) -> String {
        let monthDay = getMonthDayFromSysMonthDay(sysMonthDay: day)
        return "\(month)月 \(monthDay)"
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
        if alarm.repeatInfo.weekday != nil {
            selectDateComponents.weekday = alarm.repeatInfo.weekday
        }
        if alarm.repeatInfo.day != nil {
            selectDateComponents.day = alarm.repeatInfo.day
        }
        if alarm.repeatInfo.month != nil {
            selectDateComponents.month = alarm.repeatInfo.month
        }
        return selectDateComponents
    }
    
    static func getRepeatInfoFromAlarm(alarm: Alarm) -> String {
//        let dateComponents = getDateComponentsFromAlarm(alarm: alarm)
        let repeatTypeLabel = ALARM_REPEAT_TYPES[alarm.repeatInfo.repeatType]
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .weekdayOrdinal], from: Date())
        var dateInfo = ""
        switch alarm.repeatInfo.repeatType {
        case 3: // 每周
            if alarm.repeatInfo.weekday != nil {
                dateInfo = getWeekdayFromSysWeekday(sysWeekday: alarm.repeatInfo.weekday!)
            } else {
                dateInfo = getWeekdayFromSysWeekday(sysWeekday: currentDateComponents.weekday!)
            }
        case 4: // 每月
            if alarm.repeatInfo.day != nil {
                dateInfo = getMonthDayFromSysMonthDay(sysMonthDay: alarm.repeatInfo.day!)
            } else {
                dateInfo = getMonthDayFromSysMonthDay(sysMonthDay: currentDateComponents.day!)
            }
        case 5: // 每年
            if alarm.repeatInfo.day != nil && alarm.repeatInfo.month != nil {
                dateInfo = getYearDateFromDateCompnents(month: alarm.repeatInfo.month!, day: alarm.repeatInfo.day!)
            } else {
                dateInfo = getYearDateFromDateCompnents(month: alarm.repeatInfo.month == nil ? currentDateComponents.month! : alarm.repeatInfo.month!, day: alarm.repeatInfo.day == nil ? currentDateComponents.day! : alarm.repeatInfo.day!)
            }
        default:
            dateInfo = ""
        }
        return repeatTypeLabel + dateInfo
    }
}
