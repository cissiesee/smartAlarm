//
//  AlarmSoundRecordView.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/17.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmSoundRecordView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var recordTable: UITableView!
    @IBOutlet weak var stopRecordBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    var recordManager = RecordManager()
    var recordList: [Dictionary<String, String>] = []
    var selectIndex: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordBtn.isHidden = true
        recordBtn.isHidden = false
        recordList = recordManager.getList()
        
        if recordList.count == 0 {
            recordTable.isHidden = true
        }
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(volumeHandler), name: NSNotification.Name(rawValue: "RecordVolumeNotification"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let data = recordList[selectIndex]
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RecordSelectNotification"), object: data)
        recordManager.saveList()
    }
    
    @objc private func volumeHandler(noti: Notification) {
        let data = noti.object as! Dictionary<String, Any>
        let volumeAverageLevel = data["volumeAverageLevel"] as! Float
        let lowPassResult = data["lowPassResult"] as! Double
        if (volumeAverageLevel < 5) {
            print("音量太低")
        }
        // todo 音波图show
        print("当前音量:\(lowPassResult)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSoundRecordCell", for: indexPath) as! AlarmSoundRecordCell
        cell.textLabel?.text = recordList[indexPath.row]["name"]
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
        tableView.reloadData()
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordManager.beginRecord()//开始录音
        stopRecordBtn.isHidden = false
        recordBtn.isHidden = true
    }

    @IBAction func stopRecord(_ sender: Any) {
        self.recordManager.pauseRecord()
        let alertController = UIAlertController(title: "录音确认",
                                                message: "亲，确认使用该段录音吗？", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = self.recordManager.getDefaultName()
        }
        let cancelAction = UIAlertAction(title: "放弃", style: .cancel, handler: {
            action in
            self.recordManager.cancelRecord()
        })
        let okAction = UIAlertAction(title: "使用", style: .default, handler: {
            action in
            self.recordManager.stopRecord()
            self.recordManager.renameAudio(audioName: alertController.textFields![0].text!, successCall: { (name) in
                print("record successfull")
                self.recordList = self.recordManager.getList()
                self.recordTable.isHidden = false
                self.recordTable.reloadData()
                // self.recordManager.play(name: name)
            }, failCall: { (msg) in
                print("record failed: \(msg)")
            })
            self.stopRecordBtn.isHidden = true
            self.recordBtn.isHidden = false
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
