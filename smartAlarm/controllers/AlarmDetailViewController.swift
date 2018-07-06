//
//  AlarmDetailViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/2.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import UserNotifications

class AlarmDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var timeSelector: UIDatePicker!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var type: String = "add"
    var dateFormatter = "HH:mm"
    var alarm: Alarm = Alarm(
        id: "",
        time: "",
        info: "闹钟",
        isOn: true,
        details: AlarmDetail(repeatType: "0", sound: "")
    )
    var repeatTypes: [String] = ["仅一次", "每个工作日", "每天", "每周", "每月", "每年"]
    var detailLabels: [String] = ["重复", "铃声", "描述"]
    
    override func viewDidLoad() {
        print("AlarmDetailViewController viewDidLoad")
        super.viewDidLoad()
        if type == "edit" {
            setSelectorTime(time:alarm.time)
        }
//        detailContents = [alarm.details.repeatType, alarm.info, alarm.details.sound]
        
        // 自定义通知
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue: "RepeatSelectNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func notificationAction(noti: Notification) {
        let data = noti.object as! Dictionary<String, String>
        alarm.details.repeatType = data["selectIndex"]!
        alarm.info = "\(data["selectIndex"]!),\(data["selectedInfo"]!)"
//        detailContents[0] = alarm.details.repeatType
//        detailContents[2] = alarm.info
        detailTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCell", for: indexPath) as! AlarmDetailCell
        cell.detailLabel.text = detailLabels[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.detailContent.text = repeatTypes[Int(alarm.details.repeatType)!]
            break;
        case 1:
            cell.detailContent.text = alarm.details.sound
            break;
        case 2:
            cell.detailContent.text = alarm.details.sound
            break;
        default:
            print("")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.row == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "AlarmRepeatEditController") as! AlarmRepeatEditController
//            vc.repeatTypes = repeatTypes
//            vc.selectIndex = Int(alarm.details.repeatType)!
            vc.navigationItem.title = "周期设置"
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = storyboard.instantiateViewController(withIdentifier: "AlarmSoundEditController") as! AlarmSoundEditController
            vc.navigationItem.title = "铃声设置"
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            editInfo()
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
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(
            showCloseButton: false
        ))
        let txt = alert.addTextField("闹钟描述")
        txt.text = self.alarm.info
        alert.addButton("确定") {
            self.alarm.info = txt.text!
            self.detailTable.reloadData()
        }
        alert.addButton("取消") {
            print("闹钟描述编辑取消")
        }
        alert.showEdit("闹钟描述编辑", subTitle: "")
    }
    
    func setSelectorTime(time: String) {
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormatter
        let date = dformatter.date(from: time)
        print("current alarm date", date as Any)
        timeSelector.date = date!
    }
    
    func getSelectorTime() -> String {
        print("getSelectorTime", timeSelector.date)
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormatter
        let datestr = dformatter.string(from: timeSelector.date)
        return datestr
    }
    
    @IBAction func handleTimeSelect() {
//        alarm.time = getSelectorTime()
    }
    
    @IBAction func cancelPage() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAlarm() {
        appDelegate.removeAlarm(alarmId: alarm.id)
        deleteUserNoti(id: alarm.id)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addOrEditAlarm() {
        print("addOrEditAlarm")
        
        let date = Date()
        
        if type == "add" {
            alarm.id = "type\(alarm.details.repeatType)_\(Int(date.timeIntervalSince1970 * 1000))"
        }
        
        alarm.time = getSelectorTime()
        
        if type == "add" {
            appDelegate.addAlarm(alarm: alarm)
        } else if type == "edit" {
            appDelegate.editAlarm(alarm: alarm)
        }
        scheduleUserNotication(alarm: alarm)
        dismiss(animated: true, completion: nil)
    }
    
    func alarmWorkDayIn2018(today: Date, alarm: Alarm, content: UNMutableNotificationContent, i: Int) {
        let index = i + 1
        let oneDay = TimeInterval(60 * 60 * 24)
        let requestIdentifier = "\(alarm.id)_\(i)"
        let todayDetail = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: today)
        var components: DateComponents = DateComponents()
        components.hour = todayDetail.hour
        components.minute = todayDetail.minute
        
        if (todayDetail.year == 2018) {
//            print("weekday", todayDetail.weekday as Any)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datestr = dateFormatter.string(from: today)
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
    
    func scheduleUserNotication(alarm: Alarm) {
        //设置推送内容
        let content = UNMutableNotificationContent()
        content.title = "亲,来闹你了哦--亲爱的闹钟"
        content.body = alarm.info
        
        var components:DateComponents = DateComponents()
        let timeDetail = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: timeSelector.date)
        
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
            // 每周
            case "3":
                components.weekday = timeDetail.day
            // 每月
            case "4":
                components.month = timeDetail.month
            // 每年
            case "5":
                components.year = timeDetail.year
                break
            default:
                print(alarm.details.repeatType)
            }
            
            addOrEditUserNoti(id: alarm.id, dateMatching: components, repeats: true, content: content)
        }
    }
    
    func addOrEditUserNoti(id: String, dateMatching: DateComponents, repeats: Bool, content: UNMutableNotificationContent) {
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
    
    func deleteUserNoti(id: String) {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^type0_.*")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
