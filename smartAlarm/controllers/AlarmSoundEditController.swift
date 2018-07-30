//
//  AlarmSoundEditController.swift
//  smartAlarm
//
//  Created by linkage on 2018/7/13.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Eureka
import AudioToolbox

class AlarmSoundEditController: FormViewController {
    var soundNameList: [String] = ["test", "a2"]
    var selectSoundName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectableSection: SelectableSection = SelectableSection<ListCheckRow<String>>(
            "给一段提示音翻牌子吧",
            selectionType: .singleSelection(enableDeselection: false)
        )
        
        form +++ selectableSection

        for soundName in soundNameList {
            form.last! <<< ListCheckRow<String>(soundName){ listRow in
                listRow.title = soundName
                listRow.selectableValue = soundName
                listRow.value = soundName == selectSoundName ? soundName : nil
                }.onChange({ listRow in
                    let selectableValue = selectableSection.selectedRow()?.selectableValue
                    if selectableValue != nil {
                        self.selectSoundName = selectableValue!
                        self.playSound(soundName: selectableValue!)
                    }
                })
        }
        
        // Do any additional setup after loading the view.
    }
    
    func playSound(soundName: String) {
        print("play sound:", soundName)
        //建立的SystemSoundID对象
        var soundID: SystemSoundID = 0
        //获取声音地址
        let path = Bundle.main.path(forResource: soundName, ofType: "caf")
        //地址转换
        if path != nil {
            let baseURL = NSURL(fileURLWithPath: path!)
            //赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
            //播放声音
            AudioServicesPlaySystemSound(soundID)
        } else {
            print("play sound failed")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let data = ["selectSoundName": selectSoundName]
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "SoundSelectNotification"), object: data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
