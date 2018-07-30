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
    @IBOutlet weak var deleteBtn: UIButton!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var type: String = "add"
    var dateFormatter = "HH:mm"
    var alarm: Alarm = Alarm(
        id: "",
        time: "",
        info: "提醒",
        isOn: true,
        important: 0,
        details: AlarmDetail(repeatType: "0", repeatInfo: ALARM_REPEAT_TYPES[0], weekday: "", day: "", month: "", sound: "")
    )
    var selectTimeText = ""
    var repeatTypes: [String] = ALARM_REPEAT_TYPES
//    var detailLabels: [String] = ["重复", "铃声", "描述", "重要性"]
    var labels = [
        0: [String] (["内置类别选择"]),
        1: [String] (["时间", "重复", "铃声", "描述", "重要性"])
    ]
    var adHeaders = [
        "快速设置",
        "提醒详情设置"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AlarmDetailViewController viewDidLoad")
        if type == "edit" {
            labels[2] = ["删除提醒"]
            adHeaders.append("")
        }
        // 自定义通知
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(timeNotiHandler), name: NSNotification.Name(rawValue: "TimeSelectNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(repeatNotiHandler), name: NSNotification.Name(rawValue: "RepeatSelectNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(soundNotiHandler), name: NSNotification.Name(rawValue: "SoundSelectNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(infoNotiHandler), name: NSNotification.Name(rawValue: "InfoSelectNotification"), object: nil)
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
        alarm.details.repeatType = data["selectIndex"] as! String
        alarm.details.repeatInfo = data["repeatInfo"] as! String
        alarm.details.weekday = selectDateComponents.weekday == nil ? "" : "\(selectDateComponents.weekday!)"
        alarm.details.day = selectDateComponents.day == nil ? "" : "\(selectDateComponents.day!)"
        alarm.details.month = selectDateComponents.month == nil ? "" : "\(selectDateComponents.month!)"
        
        print("selectDateComponents", selectDateComponents)
//        print(data)
//        detailContents[0] = alarm.details.repeatType
//        detailContents[2] = alarm.info
        detailTable.reloadData()
    }
    
    @objc private func soundNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, String>
        alarm.details.sound = data["selectSoundName"]!
        detailTable.reloadData()
    }
    
    @objc private func infoNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, String>
        alarm.info = data["selectInfo"]!
        detailTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return adHeaders[section];
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels[section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let detailLabels = labels[indexPath.section]
        let labelContent = detailLabels?[indexPath.row]
        
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCellDelete", for: indexPath)
            cell.textLabel?.text = labelContent
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCell", for: indexPath) as! AlarmDetailCell
            let detailCell = cell as! AlarmDetailCell
            detailCell.detailLabel.text = labelContent
            detailCell.setType(type: "default")
            
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    detailCell.detailContent.text = "无"
                    break
                default:
                    print("")
                }
            } else if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    detailCell.setType(type: "date")
                    detailCell.setDefaultDate(date: type == "edit" ? DateUtils.getDateFromFormat(dateStr: alarm.time, formatStr: "HH:mm") : Date())
                    break
                case 1:
                    detailCell.detailContent.text = alarm.details.repeatInfo
                    break
                case 2:
                    detailCell.detailContent.text = alarm.details.sound
                    break
                case 3:
                    detailCell.detailContent.text = alarm.info
                    break
                case 4:
                    detailCell.detailContent.text = ALARM_IMPORTANT_LEVELS[alarm.important]
                    break
                default:
                    print("")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // 1 实例化
                let alertSheet = UIAlertController(title: "选择内置类别", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                let deleteAction = UIAlertAction(title: "删除", style: UIAlertActionStyle.destructive, handler: nil)
                let archiveAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: {
                    action in
                    print("OK")
                })
                alertSheet.addAction(cancelAction)
                alertSheet.addAction(deleteAction)
                alertSheet.addAction(archiveAction)
                // 3 跳转
                self.present(alertSheet, animated: true, completion: nil)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmRepeatEditController") as! AlarmRepeatEditController
                vc.repeatTypes = repeatTypes
                vc.selectIndex = Int(alarm.details.repeatType)!
                vc.weekday = alarm.details.weekday
                vc.day = alarm.details.day
                vc.month = alarm.details.month
                vc.navigationItem.title = "周期设置"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmSoundEditController") as! AlarmSoundEditController
                vc.selectSoundName = alarm.details.sound
                vc.navigationItem.title = "铃声设置"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 3 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmInfoEditController") as! AlarmInfoEditController
                vc.selectInfo = alarm.info
                vc.navigationItem.title = "描述设置"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 4 {
                let vc = storyboard.instantiateViewController(withIdentifier: "AlarmImportantEditController") as! AlarmImportantEditController
                vc.selectImportantLevel = alarm.important
                vc.navigationItem.title = "重要度设置"
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 2 {
            deleteAlarm()
        }
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
        
        alarm.time = selectTimeText
        alarm.isOn = true

        if type == "add" {
            alarm.id = "type\(alarm.details.repeatType)_\(Int(date.timeIntervalSince1970 * 1000))"
            appDelegate.addAlarm(alarm: alarm)
        } else {
            if alarm.details.repeatType != appDelegate.getAlarm(id: alarm.id)!.details.repeatType {
                appDelegate.removeAlarm(id: alarm.id)
                NotificationUtils.deleteUserNoti(id: alarm.id)
                alarm.id = "type\(alarm.details.repeatType)_\(Int(date.timeIntervalSince1970 * 1000))"
                appDelegate.addAlarm(alarm: alarm)
            } else {
                appDelegate.editAlarm(alarm: alarm)
            }
        }
        
        NotificationUtils.scheduleUserNotication(alarm: alarm, selectDateComponent: DateUtils.getDateComponentsFromAlarm(alarm: alarm))
        dismiss(animated: true, completion: nil)
    }
    
    func deleteAlarm() {
        appDelegate.removeAlarm(id: alarm.id)
        NotificationUtils.deleteUserNoti(id: alarm.id)
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
