//
//  NotificationHandler.swift
//  smartAlarm
//
//  Created by linkage on 2018/7/9.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import UserNotifications

//通知category标识符枚举
enum NotificationCategory: String {
    case news  //新闻资讯通知category
}

//通知category的action标识符枚举
enum NotificationCategoryAction: String {
    case like
    case cancel
    case comment
}

//通知响应对象
class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    //在应用内展示通知
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        //        print(response.notification.request.content.title)
        //        print(response.notification.request.content.body)
        //        //获取通知附加数据
        //        let userInfo = response.notification.request.content.userInfo
        //        print(userInfo)
        //完成了工作
        //根据category标识符做相应的处理
        let categoryIdentifier = notification.request.content.categoryIdentifier
        print(NotificationCategory(rawValue: categoryIdentifier) as Any)
//        if let category = NotificationCategory(rawValue: categoryIdentifier) {
//            switch category {
//            case .news:
//                handleNews(response: response)
//            }
//        }
        completionHandler([.alert, .sound])
        
        // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
        // completionHandler([])
    }
    
    //对通知进行响应（用户与通知进行交互时被调用）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler:
        @escaping () -> Void) {
        print(response.notification.request.content.title)
        print(response.notification.request.content.body)
        //获取通知附加数据
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        if (userInfo["repeatType"] as! Int) == 0 {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "AlarmSwitchNotification"), object: ["id": response.notification.request.identifier, "isOn": false])
        } else {
            NotificationUtils.deleteUserNotiOfRepeat(id: response.notification.request.identifier)
        }
        
        //完成了工作
        completionHandler()
    }
    
    //处理新闻资讯通知的交互
    private func handleNews(response: UNNotificationResponse) {
        let message: String
        
        //判断点击是那个action
        if let actionType = NotificationCategoryAction(rawValue: response.actionIdentifier) {
            switch actionType {
            case .like: message = "你点击了“点个赞”按钮"
            case .cancel: message = "你点击了“取消”按钮"
            case .comment:
                message = "你输入的是：\((response as! UNTextInputNotificationResponse).userText)"
            }
        } else {
            //直接点击通知，或者点击删除这个通知会进入这个分支。
            message = ""
        }
        
        //弹出相关信息
        if !message.isEmpty {
            showAlert(message: message)
        }
    }
    
    //在根视图控制器上弹出普通消息提示框
    private func showAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel))
            vc.present(alert, animated: true)
        }
    }
}
