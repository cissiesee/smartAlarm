//
//  AlarmDetailViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/2.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
//import SCLAlertView
import XLActionController

class AlarmDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var detailTable: UITableView!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var type: String = "add"
    var dateFormatter = "HH:mm"
    var alarm: Alarm?
    var selectTimeText = ""
    var repeatTypes: [String] = ALARM_REPEAT_TYPES
//    var detailLabels: [String] = ["重复", "铃声", "描述", "重要性"]
    var labels = [
        0: [String] (["内置类别", "细分类别"]),
        1: [String] (["时间", "周期", "铃声", "描述", "重要性"]),
        2: [String] (["删除提醒"])
    ]
    var adHeaders = [
        "快速设置",
        "提醒详情设置",
        ""
    ]
    
    var subTypeVisibility: Bool = false
    var selectType: Dictionary<String, Any>? = nil
    var selectSubType: Dictionary<String, Any>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AlarmDetailViewController viewDidLoad")
        if type == "edit" {
            if alarm!.subType != "" {
                subTypeVisibility = true
            }
        } else {
            resetAlarm()
            subTypeVisibility = false
        }
        // 自定义通知
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(timeNotiHandler), name: NSNotification.Name(rawValue: "TimeSelectNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(repeatNotiHandler), name: NSNotification.Name(rawValue: "RepeatSelectNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(soundNotiHandler), name: NSNotification.Name(rawValue: "SoundSelectNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(infoNotiHandler), name: NSNotification.Name(rawValue: "InfoSelectNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(importantNotiHandler), name: NSNotification.Name(rawValue: "ImportantSelectNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func timeNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, String>
        selectTimeText = data["timeText"]!
    }
    
    @objc private func repeatNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, Any>
        let selectDateComponents = data["selectDateComponents"] as! DateComponents
        print(selectDateComponents)
        alarm!.repeatInfo.repeatType = data["selectIndex"] as! Int
        alarm!.repeatInfo.repeatInfo = data["repeatInfo"] as! String
        alarm!.repeatInfo.weekday = selectDateComponents.weekday
        alarm!.repeatInfo.day = selectDateComponents.day
        alarm!.repeatInfo.month = selectDateComponents.month
        
        print("selectDateComponents", selectDateComponents)
        detailTable.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .none)
    }
    
    @objc private func soundNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, String>
        alarm!.sound = data["selectSoundName"]!
        detailTable.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .none)
    }
    
    @objc private func infoNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, String>
        alarm!.info = data["selectInfo"]!
        detailTable.reloadRows(at: [IndexPath(row: 3, section: 1)], with: .none)
    }
    
    @objc private func importantNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, AlarmImportantInfo>
        alarm!.importantInfo = data["importantInfo"]!
        detailTable.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return adHeaders[section];
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return type == "edit" ? labels.count : labels.count - 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = labels[section]!.count
        if section == 0 && !subTypeVisibility {
            count = count - 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let detailLabels = labels[indexPath.section]
        let labelContent = detailLabels?[indexPath.row]
        
        let _alarm = alarm!
        
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCellDelete", for: indexPath)
            cell.textLabel?.text = labelContent
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCell", for: indexPath) as! AlarmDetailCell
            let detailCell = cell as! AlarmDetailCell
            detailCell.detailLabel.text = labelContent
            detailCell.setType(type: "default") // default or date
            
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    detailCell.detailContent.text = _alarm.type != "" ? AlarmUtils.getAlarmLabelByType(type: _alarm.type) : ALARM_TYPES[0]["label"] as? String
                    break
                case 1:
                    detailCell.detailContent.text = (_alarm.type != "" && _alarm.subType != "") ? AlarmUtils.getAlarmLabelBySubType(type: _alarm.type, subType: _alarm.subType) : "点击选择"
                default:
                    print("")
                }
            } else if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    detailCell.setType(type: "date")
                    detailCell.setDefaultDate(date: _alarm.time != "" ? DateUtils.getDateFromFormat(dateStr: _alarm.time, formatStr: "HH:mm") : Date())
                    break
                case 1:
                    detailCell.detailContent.text = _alarm.repeatInfo.repeatInfo
                    break
                case 2:
                    detailCell.detailContent.text = _alarm.sound
                    break
                case 3:
                    detailCell.detailContent.text = _alarm.info
                    break
                case 4:
                    detailCell.detailContent.text = (ALARM_IMPORTANT_LEVELS[_alarm.importantInfo.level]["label"] as? String)! + "(提醒\(_alarm.importantInfo.repeatTimes)次" + (_alarm.importantInfo.repeatTimes > 1 ? "，间隔\(_alarm.importantInfo.repeatInterval)分钟" : "") + ")"
                    break
                default:
                    print("")
                }
//                todo
//                let image = UIImage(named:"sound.png")
//                detailCell.imageView?.image = image
            }
        }
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, actionIndexPath) in
//            //删除操作
//        }
//        let otherAction = UITableViewRowAction(style: .destructive, title: "其他") { (action, actionIndexPath) in
//            //其他操作
//        }
//        return [deleteAction]
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // 1 实例化
                let alertSheet = UIAlertController(title: "选择内置类别", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                for alarmType in ALARM_TYPES {
                    let action = UIAlertAction(title: alarmType["label"] as? String, style: UIAlertActionStyle.default, handler: {
                        action in
                        (cell as! AlarmDetailCell).detailContent.text = action.title
                        
                        let targetItems = ALARM_TYPES.filter { (item) -> Bool in
                            let label = item["label"] as? String
                            return label == action.title
                        }
                        
                        self.selectType = targetItems[0]
                        
                        self.setDetailsByType(type: self.selectType!, subType: nil)
                        
                        if targetItems.count > 0 && targetItems[0]["subTypes"] != nil {
                            if !self.subTypeVisibility {
                                self.subTypeVisibility = true
                                self.detailTable.insertRows(at: [IndexPath(row: 1, section: 0)], with: .top)
                            }
                        } else {
                            if self.subTypeVisibility {
                                self.subTypeVisibility = false
                                self.selectSubType = nil
                                self.detailTable.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .top)
                            }
                        }
                    })
                    alertSheet.addAction(action)
                }
                alertSheet.addAction(cancelAction)
                // 3 跳转
                self.present(alertSheet, animated: true, completion: nil)
            } else if (indexPath.row == 1) {
                if selectType != nil && selectType!["subTypes"] != nil {
                    let subTypes = selectType!["subTypes"] as! [Dictionary<String, Any>]
                    let alertSheet = UIAlertController(title: "选择子类别", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                    for subType in subTypes {
                        let action = UIAlertAction(title: subType["label"] as? String, style: UIAlertActionStyle.default, handler: {
                            action in
                            (cell as! AlarmDetailCell).detailContent.text = action.title
                            
                            let targetItems = (self.selectType!["subTypes"] as! [Dictionary<String, Any>]).filter { (item) -> Bool in
                                let label = item["label"] as? String
                                return label == action.title
                            }
                            
                            if targetItems.count > 0 {
                                self.selectSubType = targetItems[0]
                                self.setDetailsByType(type: self.selectType!, subType: targetItems[0])
                            }
                        })
                        alertSheet.addAction(action)
                    }
                    alertSheet.addAction(cancelAction)
                    self.present(alertSheet, animated: true, completion: nil)
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.cellForRow(at: indexPath) as! AlarmDetailCell
                cell.callDatePicker()
            } else if indexPath.row == 1 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmRepeatEditController") as! AlarmRepeatEditController
                vc.repeatTypes = repeatTypes
                vc.selectIndex = alarm!.repeatInfo.repeatType
                vc.weekday = alarm!.repeatInfo.weekday
                vc.day = alarm!.repeatInfo.day
                vc.month = alarm!.repeatInfo.month
                vc.navigationItem.title = "周期设置"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmSoundEditController") as! AlarmSoundEditController
                vc.selectSoundName = alarm!.sound
                vc.navigationItem.title = "铃声设置"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 3 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmInfoEditController") as! AlarmInfoEditController
                vc.selectInfo = alarm!.info
                vc.navigationItem.title = "描述设置"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 4 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmImportantEditController") as! AlarmImportantEditController
                vc.selectImportInfo = alarm!.importantInfo
                vc.navigationItem.title = "重要度设置"
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 2 {
            deleteAlarm()
        }
    }
    
    func resetAlarm() {
        self.alarm = Alarm(
            id: "",
            type: "",
            subType: "",
            time: "",
            info: "",
            isOn: true,
            sound: ALARM_SOUNDS[0],
            importantInfo: AlarmImportantInfo(level: 0, repeatTimes: 1, repeatInterval: 5),
            repeatInfo: AlarmRepeatInfo(repeatType: 0, repeatInfo: ALARM_REPEAT_TYPES[0], weekday: nil, day: nil, month: nil)
        )
    }
    
    // 根据内置类型填充详细内容
    func setDetailsByType(type: Dictionary<String, Any>, subType: Dictionary<String, Any>?) {
        resetAlarm()
        fulfillInfo(typeInfo: type)
        if subType != nil {
            fulfillInfo(typeInfo: subType!)
        }
        detailTable.reloadSections([1], with: .none)
    }
    
    func fulfillInfo(typeInfo: Dictionary<String, Any>) {
        let _alarm = alarm!
        if typeInfo["important"] != nil {
            alarm!.importantInfo.level = typeInfo["important"] as! Int
            let importantTarget = ALARM_IMPORTANT_LEVELS[alarm!.importantInfo.level]
            if typeInfo["repeatTimes"] != nil {
                alarm!.importantInfo.repeatTimes = typeInfo["repeatTimes"] as! Int
            } else {
                alarm!.importantInfo.repeatTimes = importantTarget["repeatTimes"] as! Int
            }
            
            if typeInfo["repeatInterval"] != nil {
                alarm!.importantInfo.repeatInterval = typeInfo["repeatInterval"] as! Int
            } else {
                alarm!.importantInfo.repeatInterval = importantTarget["repeatInterval"] as! Int
            }
        }
        
        _alarm.info = typeInfo["info"] != nil ? typeInfo["info"] as! String : typeInfo["label"] as! String
        
        if typeInfo["repeatType"] != nil {
            _alarm.repeatInfo.repeatType = typeInfo["repeatType"] as! Int
            _alarm.repeatInfo.repeatInfo = ALARM_REPEAT_TYPES[typeInfo["repeatType"] as! Int]
        }
        
        if typeInfo["remindTime"] != nil {
            _alarm.time = typeInfo["remindTime"] as! String
        } else {
            _alarm.time = "10:00"
        }
        
        if typeInfo["remindDay"] != nil {
            _alarm.repeatInfo.day = typeInfo["remindDay"] as! Int
        }
        
        if typeInfo["remindMonth"] != nil {
            _alarm.repeatInfo.month = typeInfo["remindMonth"] as! Int
        }
        
        if typeInfo["remindWeekDay"] != nil {
            _alarm.repeatInfo.weekday = typeInfo["remindWeekDay"] as! Int
        }
        
        if typeInfo["sound"] != nil {
            _alarm.sound = typeInfo["sound"] as! String
        }
        
        alarm!.repeatInfo.repeatInfo = DateUtils.getRepeatInfoFromAlarm(alarm: _alarm)
    }
    
    func editInfo() {
//        let alertController = UIAlertController(title: "请输入闹钟描述",
//                                                message: "", preferredStyle: .alert)
//        alertController.addTextField {
//            (textField: UITextField!) -> Void in
//            textField.placeholder = "" // todo
//        }
//        let cancelAction = UIAlertAction(title: "放弃", style: .cancel, handler: {
//            action in
//            print("闹钟描述编辑放弃")
//        })
//        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
//            action in
//            self.alarm.info = alertController.textFields![0].text!
//            self.detailContents[2] = self.alarm.info
//            self.detailTable.reloadData()
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(
//            showCloseButton: false
//        ))
//        let txt = alert.addTextField("闹钟描述")
//        txt.text = self.alarm.info
//        alert.addButton("确定") {
//            self.alarm.info = txt.text!
//            self.detailTable.reloadData()
//        }
//        alert.addButton("取消") {
//            print("闹钟描述编辑取消")
//        }
//        alert.showEdit("闹钟描述编辑", subTitle: "")
    }
    
    @IBAction func cancelPage() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addOrEditAlarm() {
        print("addOrEditAlarm, date:", selectTimeText)
        let date = Date()
        
        let _alarm = alarm!
        
        _alarm.time = selectTimeText
        _alarm.isOn = true
        
        if selectType != nil {
            _alarm.type = selectType!["type"] as! String
        }
        
        if selectSubType != nil {
            _alarm.subType = selectSubType!["type"] as! String
        }
        
        print("\(type) alarm:", _alarm.type)

        if type == "add" {
            _alarm.id = "type\(_alarm.repeatInfo.repeatType)_\(Int(date.timeIntervalSince1970 * 1000))"
            appDelegate.addAlarm(alarm: _alarm)
        } else {
            if _alarm.repeatInfo.repeatType != appDelegate.getAlarm(id: _alarm.id)!.repeatInfo.repeatType {
                appDelegate.removeAlarm(id: _alarm.id)
                NotificationUtils.deleteUserNoti(id: _alarm.id)
                _alarm.id = "type\(_alarm.repeatInfo.repeatType)_\(Int(date.timeIntervalSince1970 * 1000))"
                appDelegate.addAlarm(alarm: _alarm)
            } else {
                appDelegate.editAlarm(alarm: _alarm)
            }
        }
        
        NotificationUtils.scheduleUserNotication(alarm: _alarm, selectDateComponent: DateUtils.getDateComponentsFromAlarm(alarm: _alarm))
        dismiss(animated: true, completion: nil)
    }
    
    func deleteAlarm() {
        appDelegate.removeAlarm(id: alarm!.id)
        NotificationUtils.deleteUserNoti(id: alarm!.id)
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
