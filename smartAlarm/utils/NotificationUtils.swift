//
//  NotificationUtils.swift
//  smartAlarm
//
//  Created by linkage on 2018/7/15.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation
import Alamofire
import UserNotifications

class NotificationUtils {
    static func scheduleUserNotication(alarm: Alarm, selectDateComponent: DateComponents) {
        //设置推送内容
        let content = UNMutableNotificationContent()
        
        //设置category标识符
        content.categoryIdentifier = "myNotificationCategory"
        
        content.title = "亲,来闹你了哦--亲爱的闹钟"
        content.body = alarm.info
        
        if alarm.details.sound != "" {
            content.sound = UNNotificationSound(named: "\(alarm.details.sound).caf")
        }
        
        var components:DateComponents = DateComponents()
        let timeDetail = selectDateComponent
        
        print("scheduleUserNotication:", timeDetail)
        
        if alarm.details.repeatType == "0" { // 不重复的闹钟
            components.hour = timeDetail.hour
            components.minute = timeDetail.minute
            addOrEditUserNoti(id: alarm.id, dateMatching: components, repeats: false, content: content)
        } else if alarm.details.repeatType == "1" { // 每个工作日单独处理
            if LocalSaver.getFestivals().count > 0 {
                alarmWorkDayIn2018(today: Date(), alarm: alarm, content: content, i: 0)
            } else {
                Alamofire.request(host + "getFestivals", method: .get, encoding: JSONEncoding.default)
                    .responseJSON { (response) in
                        switch response.result {
                        case .success(let json):
                            print("\(json)")
                            let dict = json as! Dictionary<String, Any>
                            if dict["code"] as! String == "0" {
                                print("get festivals success")
                                let data = dict["data"] as! Dictionary<String, Any>
                                let festivalDays = data["festivalDays"] as! [Dictionary<String, String>]
                                let workDays = data["workDays"] as! [Dictionary<String, String>]
                                LocalSaver.saveFestivals(jsonData: festivalDays)
                                LocalSaver.saveWorkDays(jsonData: workDays)
                                self.alarmWorkDayIn2018(today: Date(), alarm: alarm, content: content, i: 0)
                            }
                        case .failure(let error):
                            print("\(error)")
                        }
                }
            }
        } else {
            switch alarm.details.repeatType {
            // 每天
            case "2":
                components.hour = timeDetail.hour
                components.minute = timeDetail.minute
                break
            // 每周
            case "3":
                components.hour = timeDetail.hour
                components.minute = timeDetail.minute
                components.weekday = timeDetail.weekday
                break
            // 每月
            case "4":
                components.hour = timeDetail.hour
                components.minute = timeDetail.minute
                components.day = timeDetail.day
                break
            // 每年
            case "5":
                components.hour = timeDetail.hour
                components.minute = timeDetail.minute
                components.day = timeDetail.day
                components.month = timeDetail.month
                break
            default:
                print(alarm.details.repeatType)
            }
            
            addOrEditUserNoti(id: alarm.id, dateMatching: components, repeats: true, content: content)
        }
    }
    
    static func addOrEditUserNoti(id: String, dateMatching: DateComponents, repeats: Bool, content: UNMutableNotificationContent) {
        //设置通知触发器
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: repeats)
        //设置请求标识符
        
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Calendar Notification scheduled: \(id)")
            }
        }
    }
    
    static func deleteUserNoti(id: String) {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^type1_.*")
        if predicate.evaluate(with: id) { // 工作日
            UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
                let predicateId = NSPredicate(format: "SELF MATCHES %@", "^\(id)_.*")
                for request in requests {
                    if predicateId.evaluate(with: request.identifier) {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    }
                }
            }
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }
    
    static func alarmWorkDayIn2018(today: Date, alarm: Alarm, content: UNMutableNotificationContent, i: Int) {
        let index = i + 1
        let oneDay = TimeInterval(60 * 60 * 24)
        let requestIdentifier = "\(alarm.id)_\(i)"
        let todayDetail = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: today)
        var components: DateComponents = DateComponents()
        components.hour = todayDetail.hour
        components.minute = todayDetail.minute
        
        if (todayDetail.year == 2018) {
            //            print("weekday", todayDetail.weekday as Any)
            let datestr = DateUtils.formatDate(date: today, formatStr: "yyyy-MM-dd")
            let festivalDays: [Dictionary<String, String>] = LocalSaver.getFestivals()
            let workdays: [Dictionary<String, String>] = LocalSaver.getWorkDays()
            var ifAdd = false
            if todayDetail.weekday == 7 || todayDetail.weekday == 1 { // 周末判断是否是调休日
                let isWorkday = workdays.index { (day) -> Bool in
                    return datestr == day["date"]
                }
                if isWorkday != nil {
                    ifAdd = true
                }
            } else { // 工作日判断是否是假日
                let isFestival = festivalDays.index { (day) -> Bool in
                    return datestr == day["date"]
                }
                if isFestival != nil {
                    ifAdd = true
                }
            }
            
            if ifAdd {
                components.day = todayDetail.day
                addOrEditUserNoti(id: requestIdentifier, dateMatching: components, repeats: false, content: content)
            }
            
            let newDay = Date(timeIntervalSinceNow: oneDay)
            alarmWorkDayIn2018(today: newDay, alarm: alarm, content: content, i: index)
        } else {
            return
        }
    }
}
