//
//  AppDelegate.swift
//  smartAlarm
//
//  Created by linkage on 2018/4/28.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var alarms: [Alarm] = []
    
    let notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let notificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
        
        
        //设置通知代理
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        //获取本地存储的闹铃数据
        alarms = jsonListToAlarms(jsonList: LocalSaver.getItems())
        
        return true
    }
    
//    func application(_ application: UIApplication, didReceive notification: UNUserNotificationCenter) {
////        if let userInfo = notification.userInfo{
////            let customField1 = userInfo["CustomField1"] as! String
////            print("\(#function) recive a notification: customField1 is \(customField1)")
////
////        }
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LocalSaver.saveItems(jsonData: alarmsToJsonList(alarms: alarms))
    }
    
    func alarmsToJsonList(alarms: [Alarm]) -> [Dictionary<String, Any>] {
        var jsonList: [Dictionary<String, Any>] = []
        for alarm in alarms {
            jsonList.append(alarmToJson(alarm: alarm))
        }
        return jsonList
    }
    
    func alarmToJson(alarm: Alarm) -> Dictionary<String, Any> {
        let requestData: [String:Any] = [
            "id": alarm.id,
            "time": alarm.time,
            "info": alarm.info,
            "isOn": alarm.isOn,
            "detail": [
                "repeatType": alarm.details.repeatType,
                "sound": alarm.details.sound
            ]
        ]
        return requestData
    }
    
    func jsonListToAlarms(jsonList: [Dictionary<String, Any>]) -> [Alarm] {
        var _alarms: [Alarm] = []
        print(jsonList)
        for alarmItem in jsonList {
            _alarms.append(jsonToAlarm(json: alarmItem))
        }
        return _alarms
    }
    
    func jsonToAlarm(json: Dictionary<String, Any>) -> Alarm {
        let alarmItemDetail = json["detail"] as! Dictionary<String,AnyObject>
        return Alarm(
            id: json["id"] as! String,
            time: json["time"] as! String,
            info: json["info"] as! String,
            isOn: json["isOn"] as! Bool,
            details: AlarmDetail(
                repeatType: alarmItemDetail["repeatType"] as! String,
                sound: alarmItemDetail["sound"] as! String
            )
        )
    }
    
    func removeAlarm(alarmId: String) -> [Alarm] {
        var target: Alarm? = nil
        for alarm in alarms {
            if alarm.id == alarmId {
                target = alarm
                break
            }
        }
        if target != nil {
            alarms.remove(at: alarms.index(of: target!)!)
        } else {
            print("removeAlarm error: no alarm to remove")
        }
        return alarms
    }
    
    func addAlarm(alarm: Alarm) -> [Alarm] {
        print("addAlarm", alarm)
        alarms.append(alarm)
        return alarms
    }
    
    func editAlarm(alarm: Alarm) -> [Alarm] {
        print("editAlarm", alarm)
        var targetIndex: Int? = nil
        for item in alarms.enumerated() {
            let _alarm = item.element
            if _alarm.id == alarm.id {
                targetIndex = item.offset
                break
            }
        }
        if targetIndex != nil {
            alarms[targetIndex!] = alarm
        } else {
            print("editAlarm error: no alarm to edit")
        }
        return alarms
    }
    
    func updateAlarmsToServer() {
        print("updateAlarmsToServer")
        Alamofire.request(host + "updateAlarms", method: .post, parameters: ["list": alarmsToJsonList(alarms: alarms)], encoding: JSONEncoding.default)
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    print("\(json)")
                    let dict = json as! Dictionary<String,String>
                    if dict["code"] == "0" {
                        print("update success")
                    }
                case .failure(let error):
                    print("\(error)")
                }
        }
    }
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    //在应用内展示通知
    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
//        print(response.notification.request.content.title)
//        print(response.notification.request.content.body)
//        //获取通知附加数据
//        let userInfo = response.notification.request.content.userInfo
//        print(userInfo)
        //完成了工作
        completionHandler([.alert, .sound])
        
        // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
        // completionHandler([])
    }
}

