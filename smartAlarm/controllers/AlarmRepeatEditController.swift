//
//  AlarmRepeatEditController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/20.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import Eureka

class AlarmRepeatEditController: FormViewController {
    var weekdayList = ["一", "二", "三", "四", "五", "六", "日"]
    var monthDayList: [Int] = []
    var selectedDayForWeek = ""
    var selectedDayForMonth = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultDayFromDate(date: Date())
        // todo monthdaylist init
        form +++ Section()
            <<< SwitchRow("switchOnce"){
                $0.title = "仅一次"
            }
            +++ Section()
            <<< SwitchRow("switchRowWorkDay"){
                $0.title = "工作日"
            }
            +++ Section()
            <<< SwitchRow("switchRowDay"){
                $0.title = "每天"
            }
            +++ Section()
            <<< SwitchRow("switchRowWeek"){
                $0.title = "每周"
            }
            <<< PickerInputRow<String>("dateByWeek") {
                $0.hidden = "$switchRowWeek != true"
                $0.title = "日期"
                for i in 0...6 {
                    $0.options.append("星期\(weekdayList[i])")
                }
                $0.value = selectedDayForWeek
            }
            +++ Section()
            <<< SwitchRow("switchRowMonth"){
                $0.title = "每月"
            }
            <<< PickerInputRow<String>("dateByMonth") {
                $0.hidden = "$switchRowMonth != true"
                $0.title = "日期"
                for i in 1...31 {
                    $0.options.append("\(i)日")
                }
                $0.value = selectedDayForMonth
            }
            +++ Section()
            <<< SwitchRow("switchRowYear"){
                $0.title = "每年"
            }
            <<< DateRow("dateByYear"){
                $0.hidden = "$switchRowYear != true"
                $0.title = "选择日期"
                $0.value = Date()
            }
//            +++ SelectableSection<ListCheckRow<String>>("Where do you live", selectionType: .singleSelection(enableDeselection: true))
//
//            let continents = ["Africa", "Antarctica", "Asia", "Australia", "Europe", "North America", "South America"]
//            for option in continents {
//                form.last! <<< ListCheckRow<String>(option){ listRow in
//                    listRow.title = option
//                    listRow.selectableValue = option
//                    listRow.value = nil
//                }
//            }
    }
    
    // 设置相关默认日期选择
    func setDefaultDayFromDate(date: Date) {
        let timeDetail = Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal, .hour, .minute], from: date)
        print(timeDetail)
        selectedDayForWeek = "星期\(weekdayList[(timeDetail.weekday! - 2) < 0 ? 6 : (timeDetail.weekday! - 2)])"
        selectedDayForMonth = "\(timeDetail.day!)" + "日"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print(form.values() as Any)
//        var data = [
//            "selectIndex": "\(selectIndex)",
//            "selectedDayForWeek": selectedDayForWeek,
//            "selectedDayForMonth": selectedDayForMonth,
//            "selectedDayForYear": selectedDayForYear,
//            "selectedInfo": ""
//        ]
//        switch selectIndex {
//        case 2:
//            data["selectedInfo"] = selectedDayForWeek
//            break
//        case 3:
//            data["selectedInfo"] = selectedDayForMonth
//            break
//        case 4:
//            data["selectedInfo"] = selectedDayForYear
//            break
//        default:
//            data["selectedInfo"] = "闹钟"
//        }
//        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RepeatSelectNotification"), object: data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
