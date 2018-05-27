//
//  AlarmRepeatEditController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/20.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmRepeatEditController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var alarmRepeatTable: UITableView!
    var repeatTypes: [String] = []
    var selectIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AlarmRepeatEditController viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "XMNotification"), object: "\(selectIndex)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("AlarmRepeatEditViewController, cellForRowAt:" + "\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmRepeatCell", for: indexPath)
        cell.textLabel?.text = repeatTypes[indexPath.row]
        if indexPath.row == selectIndex {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectIndex = indexPath.row
        alarmRepeatTable.reloadData()
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
