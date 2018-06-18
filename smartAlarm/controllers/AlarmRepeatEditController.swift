//
//  AlarmRepeatEditController.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/20.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmRepeatEditController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var alarmRepeatTable: UITableView!
    var repeatTypes: [String] = []
    var selectIndex: Int = -1
    var pickerView = UIPickerView()
    var datePicker = UIDatePicker()
    var dayList = ["一", "二", "三", "四", "五", "六", "日"]
    var selectedDayForWeek = ""
    var selectedDayForMonth = ""
    var selectedDayForYear = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AlarmRepeatEditController viewDidLoad")
        setDefaultDayFromDate(date: Date())
        
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        // 设置样式，当前设为同时显示日期和时间
        datePicker.datePickerMode = UIDatePickerMode.date
        // 设置默认时间
        datePicker.date = Date()
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        var data = [
            "selectIndex": "\(selectIndex)",
            "selectedDayForWeek": selectedDayForWeek,
            "selectedDayForMonth": selectedDayForMonth,
            "selectedDayForYear": selectedDayForYear,
            "selectedInfo": ""
        ]
        switch selectIndex {
        case 2:
            data["selectedInfo"] = selectedDayForWeek
            break
        case 3:
            data["selectedInfo"] = selectedDayForMonth
            break
        case 4:
            data["selectedInfo"] = selectedDayForYear
            break
        default:
            data["selectedInfo"] = "闹钟"
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RepeatSelectNotification"), object: data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 设置相关默认日期选择
    func setDefaultDayFromDate(date: Date) {
        let timeDetail = Calendar.current.dateComponents([.year, .month, .day, .weekday, .weekdayOrdinal, .hour, .minute], from: date)
        print(timeDetail)
        selectedDayForWeek = "星期\(dayList[(timeDetail.weekday! - 2) < 0 ? 6 : (timeDetail.weekday! - 2)])"
        selectedDayForMonth = "\(timeDetail.day!)" + "日"
        selectedDayForYear = "\(timeDetail.month!)月,\(timeDetail.day!)日"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("AlarmRepeatEditViewController, cellForRowAt:" + "\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmRepeatCell", for: indexPath) as! AlarmRepeatCell
        cell.repeatTypeLabel.text = repeatTypes[indexPath.row]
        if indexPath.row > 1 {
            switch indexPath.row {
            case 2:
                cell.repeatDetailLabel.text = selectedDayForWeek
                break
            case 3:
                cell.repeatDetailLabel.text = selectedDayForMonth
                break
            case 4:
                cell.repeatDetailLabel.text = selectedDayForYear
                break
            default:
                print("");
            }
        } else {
            cell.repeatDetailLabel.text = ""
        }
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
        if indexPath.row > 1 {
            selectDate(index: indexPath.row)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectIndex {
        case 2:
            return 7
        case 3:
            return 31
        default:
            return 7
        }
    }
    
    //设置选择框个选项的内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectIndex == 2 {
            return "星期\(dayList[row])"
        } else {
            return "\(row + 1)日"
        }
    }
    
    func selectDate(index: Int) {
        let alertController: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
//        // 响应事件（只要滚轮变化就会触发）
//        // datePicker.addTarget(self, action:Selector("datePickerValueChange:"), forControlEvents: UIControlEvents.ValueChanged)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default) {
            (alertAction)->Void in
            switch index {
            case 2:
                self.selectedDayForWeek = "星期\(self.dayList[self.pickerView.selectedRow(inComponent: 0)])"
                break
            case 3:
                self.selectedDayForMonth = "\(self.pickerView.selectedRow(inComponent: 0) + 1)日"
                break
            case 4:
                let dformatter = DateFormatter()
                dformatter.dateFormat = "MM, dd"
                let datestr = dformatter.string(from: self.datePicker.date)
                self.selectedDayForYear = datestr
                break
            default:
                print("")
            }
            print("date select: \(self.datePicker.date.description)")
        })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        
        if index == 4 {
            alertController.view.addSubview(datePicker)
        } else {
            pickerView.reloadComponent(0)
            alertController.view.addSubview(pickerView)
        }
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
