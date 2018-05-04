//
//  AlarmDetailViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/2.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var alarms: [Alarm] = alarmList
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var timeSelector: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        detailTable.dataSource = self
//        detailTable.delegate = self
//        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "AlarmDetailCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleTimeSelect() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("AlarmDetailViewController, cellForRowAt:" + "\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
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
