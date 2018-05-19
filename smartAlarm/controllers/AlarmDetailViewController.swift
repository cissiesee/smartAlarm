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
    var alarm: Alarm = Alarm(
        createTime: "",
        time: "",
        info: "闹钟",
        isOn: true,
        details: AlarmDetail(repeatType: "", sound: "")
    )
    var detailLabels: [String] = ["重复", "描述", "铃声"]
    var detailContents: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(alarm)
//        timeSelector.date
        detailContents = [alarm.details.repeatType, alarm.info, alarm.details.sound]
//        detailTable.dataSource = self
//        detailTable.delegate = self
//        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "AlarmDetailCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("AlarmDetailViewController, cellForRowAt:" + "\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCell", for: indexPath) as! AlarmDetailCell
        cell.detailLabel.text = detailLabels[indexPath.row]
        cell.detailContent.text = detailContents[indexPath.row]
        return cell
    }
    
    func getSelectorTime() -> String {
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm"
        // 使用日期格式器格式化日期、时间
        print("getSelectorTime", timeSelector.date)
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
        Alamofire.request(host + "deleteAlarm", method: .post, parameters: requestData, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    print("\(json)")
                    let dict = json as! Dictionary<String,String>
                    if dict["code"] == "0" {
                        self.dismiss(animated: true, completion: nil)
                        //TODO 回退上一页
                    }
                case .failure(let error):
                    print("\(error)")
                }
        }
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
        
        Alamofire.request(host + type + "Alarm", method: .post, parameters: requestData, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    print("\(json)")
                    let dict = json as! Dictionary<String,String>
                    if dict["code"] == "0" {
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("\(error)")
                }
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
