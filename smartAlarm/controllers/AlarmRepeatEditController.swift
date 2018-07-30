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
    var repeatTypes: [String] = []
    var sectionTags: [String] = ["sectionOnce", "sectionWorkDay", "sectionDay", "sectionWeek", "sectionMonth", "sectionYear"]
    var switchTags: [String] = ["switchOnce", "switchRowWorkDay", "switchRowDay", "switchRowWeek", "switchRowMonth", "switchRowYear"]
    var selectIndex = -1
    var month: String = ""
    var day: String = ""
    var weekday: String = ""
//    var selectDate: Date = Date()
//    var selectedDayForWeek = ""
//    var selectedDayForMonth = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: Date())
//        print("selectDate", DateUtils.formatDate(date: selectDate, formatStr: "yyyy-MM-dd HH:mm") )
        
//        setDefaultDayFromDate(date: selectDate)
        // todo monthdaylist init
        var sectionArr: [Section] = []
        for repeatType in repeatTypes {
            let index = repeatTypes.index(of: repeatType)!
            let section = Section()
            section.append(SwitchRow(switchTags[index]){
                $0.title = repeatTypes[index]
            }.onChange({ row in
                self.onSelectChange(switchTag: self.switchTags[index])
            }))
            switch index {
            case 3:
                section.append(PickerInputRow<String>("dateByWeek") {
                    $0.hidden = "$switchRowWeek != true"
                    $0.title = "日期"
                    $0.options = DateUtils.getWeekdayList()
                    $0.value = DateUtils.getWeekdayFromSysWeekday(sysWeekday: weekday == "" ? currentDateComponents.weekday! : Int(weekday)!)
                })
                break
            case 4:
                section.append(PickerInputRow<String>("dateByMonth") {
                    $0.hidden = "$switchRowMonth != true"
                    $0.title = "日期"
                    $0.options = DateUtils.getMonthdayList()
                    $0.value = DateUtils.getMonthDayFromSysMonthDay(sysMonthDay: day == "" ? currentDateComponents.day! : Int(day)!)
                })
                break
            case 5:
                section.append(DateRow("dateByYear") {
                    $0.hidden = "$switchRowYear != true"
                    $0.title = "日期"
                    if month != "" && day != "" {
                        var selectDateComponents = DateComponents()
                        selectDateComponents.month = Int(month)
                        selectDateComponents.day = Int(day)
                        selectDateComponents.year = currentDateComponents.year
                        $0.value = Calendar.current.date(from: selectDateComponents) // todo
                    } else {
                        $0.value = Date() // todo
                    }
                })
                break
            default:
                print("")
            }
            sectionArr.append(section)
        }
        
        form += sectionArr
        
//        +++ SelectableSection<ListCheckRow<String>>("Where do you live", selectionType: .singleSelection(enableDeselection: true))
//
//        let continents = ["Africa", "Antarctica", "Asia", "Australia", "Europe", "North America", "South America"]
//        for option in continents {
//            form.last! <<< ListCheckRow<String>(option){ listRow in
//                listRow.title = option
//                listRow.selectableValue = option
//                listRow.value = nil
//            }
//        }
        
        if selectIndex > -1 {
            let targetSwitchRow = form.rowBy(tag: switchTags[selectIndex]) as! SwitchRow
            targetSwitchRow.value = true
        }
    }
    
    func onSelectChange(switchTag: String) {
        let targetSwitchRow = (form.rowBy(tag: switchTag) as! SwitchRow)
        if targetSwitchRow.value == true {
            selectIndex = switchTags.index(of: switchTag)!
            for tag in switchTags {
                if tag != switchTag {
                    let switchRow = (form.rowBy(tag: tag) as! SwitchRow)
                    if switchRow.value == true {
                        switchRow.value = false
                        switchRow.updateCell()
                    }
                }
            }
        }
    }
    
    // 设置相关默认日期选择
//    func setDefaultDayFromDate(date: Date) {
//        let timeDetail = Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal, .hour, .minute], from: date)
//        print(timeDetail)
//        selectedDayForWeek = "星期\(weekdayList[(timeDetail.weekday! - 2) < 0 ? 6 : (timeDetail.weekday! - 2)])"
//        selectedDayForMonth = "\(timeDetail.day!)日"
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print(form.values() as Any)
//        let selectDateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: selectDate)
        var data: Dictionary<String, Any> = [
            "selectIndex": "\(selectIndex)"
        ]
        var repeatDateInfo = ""
        data["selectIndex"] = "\(selectIndex)"
        switch selectIndex {
        case 3:
            var dateComponents = DateComponents()
            dateComponents.weekday = DateUtils.getSysWeekdayFromWeekday(weekday: form.values()["dateByWeek"] as! String)
            data["selectDateComponents"] = dateComponents
            repeatDateInfo = form.values()["dateByWeek"] as! String
            break
        case 4:
            var dateComponents = DateComponents()
            dateComponents.day = DateUtils.getSysMonthDayFromMonthDay(monthDay: form.values()["dateByMonth"] as! String)
            data["selectDateComponents"] = dateComponents
            repeatDateInfo = form.values()["dateByMonth"] as! String
            break
        case 5:
            data["selectDateComponents"] = Calendar.current.dateComponents([.month, .day], from: form.values()["dateByYear"] as! Date)
            repeatDateInfo = DateUtils.formatDate(date: form.values()["dateByYear"] as! Date, formatStr: "MM/dd")
            break
        default:
//            data["selectDateLabel"] = ""
            data["selectDateComponents"] = DateComponents()
        }
        data["repeatInfo"] = ALARM_REPEAT_TYPES[selectIndex] + (repeatDateInfo == "" ? "" : " \(repeatDateInfo)")
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RepeatSelectNotification"), object: data)
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
