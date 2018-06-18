//
//  AlarmSoundRecordView.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/17.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmSoundRecordView: UIViewController {
    @IBOutlet weak var recordBtn: UIButton!
    var recordManager = RecordManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        if recordBtn.titleLabel?.text == "开始录音" {
            // todo 音波图show
            recordManager.beginRecord()//开始录音
            recordBtn.titleLabel?.text = "结束录音"
        } else {
            let alertController = UIAlertController(title: "录音确认",
                                                    message: "亲，确认使用该段录音吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "放弃", style: .cancel, handler: {
                action in
                self.recordManager.cancelRecord()
            })
            let okAction = UIAlertAction(title: "使用", style: .default, handler: {
                action in
                self.recordManager.stopRecord()
                self.recordBtn.titleLabel?.text = "开始录音"
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        //        recoder_manager.stopRecord()//结束录音
        //        recoder_manager.play()//播放录制的音频
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
