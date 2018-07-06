//
//  AlarmSoundEditController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/22.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmSoundEditController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var soundTable: UITableView!
    var tableInfo: [Dictionary<String, String>] = [["soundType": "record", "soundTypeName": "录音", "soundContent": ""], ["soundType": "localM", "soundTypeName": "内置音乐", "soundContent": ""], ["soundType": "online", "soundTypeName": "在线乐库", "soundContent": ""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(recordSelectNotiAction), name: NSNotification.Name(rawValue: "RecordSelectNotification"), object: nil)
        //        showLocalView()
        // Do any additional setup after loading the view.
    }
    
    @objc private func recordSelectNotiAction(noti: Notification) {
        let data = noti.object as! Dictionary<String, String>
        tableInfo[0]["soundContent"] = data["name"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableInfo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSoundCell", for: indexPath) as! AlarmSoundCell
        cell.soundType.text = data["soundTypeName"]
        cell.soundContent.text = data["soundContent"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController? = nil
        if indexPath.row == 0 {
            vc = storyboard.instantiateViewController(withIdentifier: "AlarmSoundRecordView")
            vc?.navigationItem.title = "本地录音"
        } else if indexPath.row == 1 {
            vc = storyboard.instantiateViewController(withIdentifier: "AlarmSoundLocalView")
            vc?.navigationItem.title = "本地铃声"
        } else if indexPath.row == 2 {
            vc = storyboard.instantiateViewController(withIdentifier: "AlarmSoundOnlineView")
            vc?.navigationItem.title = "在线铃声"
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
    
//    @IBOutlet weak var tabControl: UISegmentedControl!
//    @IBOutlet weak var recordView: UIView!
//    @IBOutlet weak var localView: UIView!
//    @IBOutlet weak var onlineView: UIView!
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func tabChanged(_ sender: UISegmentedControl) {
//        switch tabControl.selectedSegmentIndex {
//        case 0:
//            showLocalView()
//        case 1:
//            showOnlineView()
//        default:
//            break;
//        }
//    }
//
//    func showLocalView() {
//        localView.isHidden = false
//        onlineView.isHidden = true
//    }
//
//    func showOnlineView() {
//        localView.isHidden = true
//        onlineView.isHidden = false
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
