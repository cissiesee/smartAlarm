//
//  AlarmSoundRecordView.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/17.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmSoundRecordView: UIViewController {
    @IBOutlet weak var stopRecordBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    var recordManager = RecordManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordBtn.isHidden = true
        recordBtn.isHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        // todo 音波图show
        recordManager.beginRecord()//开始录音
        stopRecordBtn.isHidden = false
        recordBtn.isHidden = true
    }

    @IBAction func stopRecord(_ sender: Any) {
        self.recordManager.stopRecord()
        let alertController = UIAlertController(title: "录音确认",
                                                message: "亲，确认使用该段录音吗？", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "声音名称"
        }
        let cancelAction = UIAlertAction(title: "放弃", style: .cancel, handler: {
            action in
            self.recordManager.cancelRecord()
        })
        let okAction = UIAlertAction(title: "使用", style: .default, handler: {
            action in
            self.recordManager.renameAudio(audioName: alertController.textFields![0].text!, successCall: { (name) in
                print("record successfull")
                self.recordManager.play(name: name)
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
