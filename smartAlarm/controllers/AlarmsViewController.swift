//
//  AlarmsViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/4/28.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsViewController: UITableViewController {
    var alarms: [Alarm] = []
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AlarmsViewController did load")
        getNotificationAuthorization()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(alarmSwitchNotiHandler), name: NSNotification.Name(rawValue: "AlarmSwitchNotification"), object: nil)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 13
//        dateComponents.minute = 03
//
//        let content = UNMutableNotificationContent()
//        content.categoryIdentifier = "myNotificationCategory"
//        content.title = "亲,来闹你了哦--亲爱的闹钟"
//        content.body = "闹钟"
//
//        NotificationUtils.addOrEditUserNoti(id: "12345", dateMatching: dateComponents, repeats: false, content: content)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AlarmsViewController viewDidAppear")
        updateAlarmsData()
    }
    
    func getNotificationAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .authorized:
                return
            case .notDetermined:
                //请求授权
                UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound, .badge]) {
                        (accepted, error) in
                        if !accepted {
                            print("用户不允许消息通知。")
                        }
                }
            case .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                    let alertController = UIAlertController(title: "消息推送已关闭",
                                                            message: "想要闹钟提醒生效，请点击“设置”，开启通知。",
                                                            preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                    
                    let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                        (action) -> Void in
                        let url = URL(string: UIApplicationOpenSettingsURLString)
                        if let url = url, UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],
                                                          completionHandler: {
                                                            (success) in
                                })
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    })
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }
    }
    
    func updateAlarmsData() {
        alarms = appDelegate.alarms
        tableView.reloadData()
    }
    
    @objc private func alarmSwitchNotiHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, Any>
        let isOn = data["isOn"] as! Bool
        let id = data["id"] as! String
        let targetAlarms = alarms.filter({ (alarm) -> Bool in
            return alarm.id == id
        })
        if targetAlarms.count > 0 {
            let targetAlarm = targetAlarms[0]
            targetAlarm.isOn = isOn
            if isOn {
                NotificationUtils.scheduleUserNotication(alarm: targetAlarm, selectDateComponent: DateUtils.getDateComponentsFromAlarm(alarm: targetAlarm))
            } else {
                NotificationUtils.deleteUserNoti(id: id)
            }
        } else {
            print("no target found")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("AlarmsViewController, cellForRowAt:" + "\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        let alarm = alarms[indexPath.row] as Alarm
        cell.timeLabel.text = alarm.time
        cell.alarmId = alarm.id
        cell.repeatLabel.text = ""
        cell.infoLabel.text = alarm.details.repeatInfo
        cell.enableSwitch.isOn = alarm.isOn
        cell.changeColor()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let targetAlarm = alarms[indexPath.row]
        
        self.performSegue(withIdentifier: "EditDetailView", sender: targetAlarm)
    }
    
    @IBAction override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("alarmviewcontroller, prepare")
        if segue.identifier == "EditDetailView"{
            let navController = segue.destination as! UINavigationController
            let desController = navController.topViewController as! AlarmDetailViewController
            desController.navigationItem.title = "编辑闹钟"
            desController.type = "edit"
            desController.alarm = sender as! Alarm
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
