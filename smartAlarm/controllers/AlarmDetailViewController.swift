//
//  AlarmDetailViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/2.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Alamofire

class AlarmDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var timeSelector: UIDatePicker!
    
    var type: String = "add"
    var dateFormatter = "HH:mm"
    var alarm: Alarm = Alarm(
        createTime: "",
        time: "",
        info: "闹钟",
        isOn: true,
        details: AlarmDetail(repeatType: "0", sound: "")
    )
    var repeatTypes: [String] = ["每个工作日", "每天", "每周", "每月", "每年"]
    var detailLabels: [String] = ["重复", "描述", "铃声"]
    var detailContents: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(alarm)
        if type == "edit" {
            setSelectorTime(time:alarm.time)
        }
        detailContents = [alarm.details.repeatType, alarm.info, alarm.details.sound]
        /// 通知名
        let notificationName = "XMNotification"
        /// 自定义通知
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue: notificationName), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func notificationAction(noti: Notification) {
        alarm.details.repeatType = noti.object as! String
        detailContents[0] = alarm.details.repeatType
        detailTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("AlarmDetailViewController, cellForRowAt:" + "\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCell", for: indexPath) as! AlarmDetailCell
        cell.detailLabel.text = detailLabels[indexPath.row]
        if indexPath.row == 0 {
            cell.detailContent.text = repeatTypes[Int(detailContents[indexPath.row])!]
        } else {
            cell.detailContent.text = detailContents[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController? = nil
        if indexPath.row == 0 {
            vc = storyboard.instantiateViewController(withIdentifier: "AlarmRepeatEditController")
            (vc as! AlarmRepeatEditController).repeatTypes = repeatTypes
            (vc as! AlarmRepeatEditController).selectIndex = Int(alarm.details.repeatType)!
        } else if indexPath.row == 1 {
            vc = storyboard.instantiateViewController(withIdentifier: "AlarmInfoEditController")
        } else if indexPath.row == 2 {
            vc = storyboard.instantiateViewController(withIdentifier: "AlarmSoundEditController")
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setSelectorTime(time: String) {
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormatter
        let date = dformatter.date(from: time)
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
        let requestData = ["createTime": alarm.createTime]
        LocalSaver.removeItem(jsonData: requestData)
        dismiss(animated: true, completion: nil)
//        Alamofire.request(host + "deleteAlarm", method: .post, parameters: requestData, encoding: JSONEncoding.default)
//            .responseJSON { (response) in
//                switch response.result {
//                case .success(let json):
//                    print("\(json)")
//                    let dict = json as! Dictionary<String,String>
//                    if dict["code"] == "0" {
//                        self.dismiss(animated: true, completion: nil)
//                        //TODO 回退上一页
//                    }
//                case .failure(let error):
//                    print("\(error)")
//                }
//        }
    }
    
    @IBAction func addOrEditAlarm() {
        print("addOrEditAlarm")
        let date = NSDate()
        
        if type == "add" {
            alarm.createTime = "\(Int(date.timeIntervalSince1970 * 1000))"
        }
        
        alarm.time = getSelectorTime()
        
        //TODO 对alarm进行赋值
        
        let requestData: [String:Any] = [
            "createTime": alarm.createTime,
            "time": alarm.time,
            "info": alarm.info,
            "isOn": alarm.isOn,
            "detail": [
                "repeatType": alarm.details.repeatType,
                "sound": alarm.details.sound
            ]
        ]
        
        if type == "add" {
            LocalSaver.addItem(jsonData: requestData)
        } else {
            LocalSaver.editItem(jsonData: requestData)
        }
        
        dismiss(animated: true, completion: nil)
        
//        LocalSaver.addItem(jsonData: requestData)
        
//        print("localdata", LocalSaver.getData()[0])
        
//        Alamofire.request(host + type + "Alarm", method: .post, parameters: requestData, encoding: JSONEncoding.default)
//            .responseJSON { (response) in
//                switch response.result {
//                case .success(let json):
//                    print("\(json)")
//                    let dict = json as! Dictionary<String,String>
//                    if dict["code"] == "0" {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                case .failure(let error):
//                    print("\(error)")
//                }
//        }
    }
    
    @IBAction func backhere() {
        
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
