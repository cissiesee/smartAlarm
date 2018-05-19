//
//  AlarmsViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/4/28.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Alamofire

class AlarmsViewController: UITableViewController {
    var alarms: [Alarm] = []
    override func viewDidLoad() {
        print("AlarmsViewController did load")
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("AlarmsViewController viewDidAppear")
        updateAlarmsData()
    }
    
    func updateAlarmsData(fromServer: Bool = true) {
        if fromServer {
            Alamofire.request(host + "getAlarms", method: .get, encoding: JSONEncoding.default)
                .responseJSON { (response) in
                    print(response.result)
                    switch response.result {
                    case .success(let json):
                        // print("\(json)")                        //打印JSON数据
                        // print("\(type(of: json))")              //JSON的动态类型
                        let dict = json as! Dictionary<String,AnyObject>
                        // print(dict)
                        let data = dict["data"] as! Dictionary<String,AnyObject>
                        // print(data)
                        let list = data["list"] as! Array<AnyObject>
                        print(list)
                        self.alarms = []
                        for alarmItem in list {
                            let alarmItemDetail = alarmItem["detail"] as! Dictionary<String,AnyObject>
                            self.alarms.append(Alarm(
                                createTime: alarmItem["createTime"] as! String,
                                time: alarmItem["time"] as! String,
                                info: alarmItem["info"] as! String,
                                isOn: alarmItem["isOn"] as! Bool,
                                details: AlarmDetail(
                                    repeatType: alarmItemDetail["repeatType"] as! String,
                                    sound: alarmItemDetail["sound"] as! String
                                ))
                            )
                        }
                        self.tableView.reloadData()
                        // print("\(origin)")
                        // let headers = dict["headers"] as! Dictionary<String,String>
                        // let AcceptEncoding = headers["Accept-Encoding"]
                        // print("\(String(describing: AcceptEncoding))")
                    case .failure(let error):
                        print("\(error)")
                    }
            }
        } else {
            self.tableView.reloadData()
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
        cell.infoLabel.text = alarm.info
        cell.enableSwitch.isOn = alarm.isOn
        cell.handleSwitch()

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
