//
//  AlarmInfoEditController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/22.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Eureka

class AlarmInfoEditController: FormViewController {
    var infoList: [String] = ["起床上班了"]
    var selectInfo: String = ""
    var customInfo: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectableSection: SelectableSection = SelectableSection<ListCheckRow<String>>(
            "内置描述",
            selectionType: .singleSelection(enableDeselection: true)
        )
        
        form +++ selectableSection
        
        for info in infoList {
            form.last! <<< ListCheckRow<String>(info){ listRow in
                listRow.title = info
                listRow.selectableValue = info
                listRow.value = info
                }.onChange({ listRow in
                    let selectableValue = selectableSection.selectedRow()?.selectableValue
                    if selectableValue != nil {
                        self.selectInfo = selectableValue!
                    }
                })
        }
        
        form +++ Section()
            <<< SwitchRow("customSwitch"){
                $0.title = "自定义描述"
                }.onChange({ row in
                    if row.value == true {
                        self.selectInfo = ""
                        let selectRow = selectableSection.selectedRow()
                        if selectRow != nil {
                            selectRow?.value = nil
                            selectRow?.updateCell()
                        }
                    }
                })
            <<< TextRow(){ row in
                row.hidden = "$customSwitch != true"
                row.title = "描述内容"
                row.placeholder = "点击编写"
                }.onChange({ (row) in
                    if row.value != nil {
                        self.customInfo = row.value!
                    } else {
                        self.customInfo = ""
                    }
                })

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let data = ["selectInfo": selectInfo]
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "InfoSelectNotification"), object: data)
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
