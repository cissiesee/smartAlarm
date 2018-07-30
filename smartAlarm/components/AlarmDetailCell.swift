//
//  AlarmDetailCell.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/18.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit

class AlarmDetailCell: UITableViewCell {

    @IBOutlet weak var detailInfoInput: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailContent: UILabel!
    
    var type = "default" // "date"
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setType(type: String) {
        self.type = type
        if type == "default" {
            detailContent.isHidden = false
            detailInfoInput.isHidden = true
        } else {
            detailContent.isHidden = true
            detailInfoInput.isHidden = false
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44) )
            let btnback = UIBarButtonItem(
                title: "Done",
                style: UIBarButtonItemStyle.done,
                target: self,action: #selector(doneClick)
            );
            toolbar.setItems([btnback], animated: false)
            detailInfoInput.inputAccessoryView = toolbar
            detailInfoInput.textAlignment = .right
            
            datePicker.datePickerMode = UIDatePickerMode.time
            detailInfoInput.inputView = datePicker
        }
    }
    
    func setDefaultDate(date: Date) {
        datePicker.date = date
        selectDate(date: date)
    }
    
    func selectDate(date: Date) {
        detailInfoInput.text = DateUtils.formatDate(date: date, formatStr: "HH:mm")
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "TimeSelectNotification"), object: ["timeText": detailInfoInput.text])
    }
    
    func selectType() {
        
    }
    
    @objc func doneClick(sender: UIBarButtonItem) {
        switch type {
        case "date":
            selectDate(date: datePicker.date)
        case "type":
            selectType()
        default:
            print("")
        }
        detailInfoInput.resignFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
