//
//  AlarmInsetTypeController.swift
//  smartAlarm
//
//  Created by linkage on 2018/7/30.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Eureka

class AlarmInsetTypeController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let selectableSection: SelectableSection = SelectableSection<ListCheckRow<String>>(
//            "选择",
//            selectionType: .singleSelection(enableDeselection: false)
//        )
//
//        form +++ selectableSection
//
//        for soundName in soundNameList {
//            form.last! <<< ListCheckRow<String>(soundName){ listRow in
//                listRow.title = soundName
//                listRow.selectableValue = soundName
//                listRow.value = soundName == selectSoundName ? soundName : nil
//                }.onChange({ listRow in
//                    let selectableValue = selectableSection.selectedRow()?.selectableValue
//                    if selectableValue != nil {
//                        self.selectSoundName = selectableValue!
//                        self.playSound(soundName: selectableValue!)
//                    }
//                })
//        }
        // Do any additional setup after loading the view.
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
