//
//  LocalSaver.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/26.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation

class LocalSaver {
    static func getLocalFile() -> String {
        // 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        // 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString
        // 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("data.plist")
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
    
    static func saveItems(jsonData: [Dictionary<String, Any>]) {
        let filePath = getLocalFile()
        let dataSource = NSArray(array: jsonData)
        dataSource.write(toFile: filePath, atomically: true)
    }
    
    static func addItem(jsonData: Dictionary<String, Any>) {
        let filePath = getLocalFile()
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        dataSource?.add(jsonData)
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func editItem(jsonData: Dictionary<String, Any>) {
        let filePath = getLocalFile()
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        let target = findObjectInArray(array: dataSource as! [Dictionary<String, Any>], contains: jsonData)
        print("editItem", target as Any, dataSource?.index(of: target as Any) as Any)
        if target != nil {
            dataSource?.replaceObject(at: (dataSource?.index(of: target as Any))!, with: jsonData)
        }
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func removeItem(jsonData: Dictionary<String, Any>) {
        let filePath = getLocalFile()
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        let target = findObjectInArray(array: dataSource as! [Dictionary<String, Any>], contains: jsonData)
        if target != nil {
            dataSource?.removeObject(at: (dataSource?.index(of: target as Any))!)
        }
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func clearItems() {
        let filePath = getLocalFile()
        let dataSource = NSMutableArray(contentsOfFile: filePath)
        dataSource?.removeAllObjects()
        dataSource?.write(toFile: filePath, atomically: true)
    }
    
    static func getItems() -> NSArray {
        let filePath = getLocalFile()
        let dataSource = NSArray(contentsOfFile: filePath)
        return dataSource!
    }
}
