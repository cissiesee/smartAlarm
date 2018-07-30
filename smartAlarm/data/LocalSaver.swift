//
//  LocalSaver.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/26.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation

class LocalSaver {
    static func getLocalFile(fileName: String) -> String {
        // 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        // 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString
        // 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("alarm.plist")
        return filePath
    }
    
    static func findObjectInArray(array: [Dictionary<String, Any>], contains: Dictionary<String, Any>) -> Dictionary<String, Any>? {
        var targetItem: Dictionary<String, Any>? = nil
        for item in array {
            print("findObjectInArray", item["createTime"] as Any, contains["createTime"] as Any)
            if item["createTime"] as! String == contains["createTime"] as! String {
                targetItem = item
                break
            }
        }
        return targetItem
    }
    
    static func saveFestivals(jsonData: [Dictionary<String, String>]) {
        print("localsaver saveFestivals")
        let filePath = getLocalFile(fileName: "festivals.plist")
        let dataSource = NSArray(array: jsonData)
        dataSource.write(toFile: filePath, atomically: true)
    }
    
    static func saveWorkDays(jsonData: [Dictionary<String, String>]) {
        print("localsaver saveWorkDays")
        let filePath = getLocalFile(fileName: "workdays.plist")
        let dataSource = NSArray(array: jsonData)
        dataSource.write(toFile: filePath, atomically: true)
    }
    
    static func getFestivals() -> [Dictionary<String, String>] {
        print("localsaver getFestivals")
        let filePath = getLocalFile(fileName: "festivals.plist")
        var dataSource = NSArray(contentsOfFile: filePath)
        dataSource = dataSource == nil ? [] : dataSource
        return dataSource as! [Dictionary<String, String>]
    }
    
    static func getWorkDays() -> [Dictionary<String, String>] {
        print("localsaver getWorkDays")
        let filePath = getLocalFile(fileName: "workdays.plist")
        var dataSource = NSArray(contentsOfFile: filePath)
        dataSource = dataSource == nil ? [] : dataSource
        return dataSource as! [Dictionary<String, String>]
    }
    
    static func saveItems(jsonData: [Dictionary<String, Any>]) {
        print("localsaver saveItems", jsonData)
        let filePath = getLocalFile(fileName: "alarm.plist")
        let dataSource = NSArray(array: jsonData)
        dataSource.write(toFile: filePath, atomically: true)
    }
    
    static func addItem(jsonData: Dictionary<String, Any>) {
        print("localsaver addItem")
        let filePath = getLocalFile(fileName: "alarm.plist")
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        dataSource?.add(jsonData)
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func editItem(jsonData: Dictionary<String, Any>) {
        print("localsaver editItem")
        let filePath = getLocalFile(fileName: "alarm.plist")
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        let target = findObjectInArray(array: dataSource as! [Dictionary<String, Any>], contains: jsonData)
        print("editItem", target as Any, dataSource?.index(of: target as Any) as Any)
        if target != nil {
            dataSource?.replaceObject(at: (dataSource?.index(of: target as Any))!, with: jsonData)
        }
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func removeItem(jsonData: Dictionary<String, Any>) {
        print("localsaver removeItem")
        let filePath = getLocalFile(fileName: "alarm.plist")
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        let target = findObjectInArray(array: dataSource as! [Dictionary<String, Any>], contains: jsonData)
        if target != nil {
            dataSource?.removeObject(at: (dataSource?.index(of: target as Any))!)
        }
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func clearItems() {
        print("localsaver clearItems")
        let filePath = getLocalFile(fileName: "alarm.plist")
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        dataSource?.removeAllObjects()
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func getItems() -> [Dictionary<String, Any>] {
        print("localsaver getItems")
        let filePath = getLocalFile(fileName: "alarm.plist")
        var dataSource = NSArray(contentsOfFile: filePath)
        dataSource = dataSource == nil ? [] : dataSource
        return dataSource as! [Dictionary<String, Any>]
    }
}
