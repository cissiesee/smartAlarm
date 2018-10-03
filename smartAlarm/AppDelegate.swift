//
//  AppDelegate.swift
//  smartAlarm
//
//  Created by linkage on 2018/4/28.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Alamofire
//import WXApi
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var alarms: [Alarm] = []
    var wether = ""
    
    let notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        Thread.sleep(forTimeInterval: 2)
        // Override point for customization after application launch.
//        let notificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
        
        // 注册category
//        registerNotificationCategory()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
//        self.window!.rootViewController = mainViewController
        
        // 设置通知代理
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        //获取本地存储的闹铃数据
        alarms = jsonListToAlarms(jsonList: LocalSaver.getItems())
        
        print("get init alarms", alarms)
        
        return true
    }
    
    //注册一个category
//    private func registerNotificationCategory() {
//        let newsCategory: UNNotificationCategory = {
//            //创建输入文本的action
//            let inputAction = UNTextInputNotificationAction(
//                identifier: NotificationCategoryAction.comment.rawValue,
//                title: "评论",
//                options: [.foreground],
//                textInputButtonTitle: "发送",
//                textInputPlaceholder: "在这里留下你想说的话...")
//
//            //创建普通的按钮action
//            let likeAction = UNNotificationAction(
//                identifier: NotificationCategoryAction.like.rawValue,
//                title: "点个赞",
//                options: [.foreground])
//
//            //创建普通的按钮action
//            let cancelAction = UNNotificationAction(
//                identifier: NotificationCategoryAction.cancel.rawValue,
//                title: "取消",
//                options: [.destructive])
//
//            //创建category
//            return UNNotificationCategory(identifier: NotificationCategory.news.rawValue,
//                                          actions: [inputAction, likeAction, cancelAction],
//                                          intentIdentifiers: [], options: [.customDismissAction])
//        }()
//
//        //把category添加到通知中心
//        UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
//    }
    
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
        let requestData: [String: Any] = [
            "id": alarm.id,
            "type": alarm.type,
            "subType": alarm.subType,
            "time": alarm.time,
            "info": alarm.info,
            "isOn": alarm.isOn,
            "sound": alarm.sound,
            "importantInfo": [
                "level": alarm.importantInfo.level,
                "repeatTimes": alarm.importantInfo.repeatTimes,
                "repeatInterval": alarm.importantInfo.repeatInterval
            ],
            "repeatInfo": [
                "repeatType": alarm.repeatInfo.repeatType,
                "repeatInfo": alarm.repeatInfo.repeatInfo,
                "weekday": alarm.repeatInfo.weekday == nil ? -1 : alarm.repeatInfo.weekday!,
                "day": alarm.repeatInfo.day == nil ? -1 : alarm.repeatInfo.day!,
                "month": alarm.repeatInfo.month == nil ? -1 : alarm.repeatInfo.month!
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
        let alarmItemImportantInfo = json["importantInfo"] as! Dictionary<String,AnyObject>
        let alarmItemRepeatInfo = json["repeatInfo"] as! Dictionary<String,AnyObject>
        
        return Alarm(
            id: json["id"] as! String,
            type: json["type"] as! String,
            subType: json["subType"] as! String,
            time: json["time"] as! String,
            info: json["info"] as! String,
            isOn: json["isOn"] as! Bool,
            sound: json["sound"] as! String,
            importantInfo: AlarmImportantInfo(
                level: alarmItemImportantInfo["level"] as! Int,
                repeatTimes: alarmItemImportantInfo["repeatTimes"] as! Int,
                repeatInterval: alarmItemImportantInfo["repeatInterval"] as! Int
            ),
            repeatInfo: AlarmRepeatInfo(
                repeatType: alarmItemRepeatInfo["repeatType"] as! Int,
                repeatInfo: alarmItemRepeatInfo["repeatInfo"] as! String,
                weekday: alarmItemRepeatInfo["weekday"] as! Int == -1 ? nil : alarmItemRepeatInfo["weekday"] as? Int,
                day: alarmItemRepeatInfo["day"] as! Int == -1 ? nil : alarmItemRepeatInfo["day"] as? Int,
                month: alarmItemRepeatInfo["month"] as! Int == -1 ? nil : alarmItemRepeatInfo["month"] as? Int
            )
        )
    }
    
    func removeAlarm(id: String) -> [Alarm] {
        var target: Alarm? = nil
        for alarm in alarms {
            if alarm.id == id {
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
    
    func getAlarm(id: String) -> Alarm? {
        print("getAlarm, id: ", id)
        var targetIndex: Int? = nil
        var targetAlarm: Alarm? = nil
        for item in alarms.enumerated() {
            let _alarm = item.element
            if _alarm.id == id {
                targetIndex = item.offset
                break
            }
        }
        if targetIndex != nil {
            targetAlarm = alarms[targetIndex!]
        }
        
        return targetAlarm
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

