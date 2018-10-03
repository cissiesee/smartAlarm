//
//  constant.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/18.
//  Copyright © 2018年 hzt. All rights reserved.
//

//let host = "http://106.14.141.138/api"
let host = "http://192.168.1.104:5000/api"
let DATA_APP_KEY = "e03422b96918afa1"

let ALARM_TYPES = [
    ["type": "custom", "label": "自定义"],
    ["type": "morning", "label": "早安提醒", "info": "起床了，早安", "important": 2, "repeatType": 1, "remindTime": "7:00"],
    ["type": "repay", "label": "还贷提醒", "important": 2, "repeatType": 4, "subTypes": [
        ["type": "house_loan", "label": "房贷"],
        ["type": "ant_huabei", "label": "蚂蚁花呗", "repayDay": 9, "remindDay": 8, "sound": "test"],
        ["type": "jingdong_baitiao", "label": "京东白条", "repayDay": 15, "remindDay": 13],
        ["type": "suning_renxingfu", "label": "苏宁任性付", "repayDay": 15, "remindDay": 13],
        ["type": "credit_card", "label": "信用卡"]
    ]],
    ["type": "birthday", "label": "生日提醒", "important": 1, "repeatType": 5],
    ["type": "investment", "label": "投资提醒", "important": 1, "repeatType": 6, "subTypes": [
        ["type": "yuebao", "label": "余额宝", "remindTime": "9:00", "repeatInterval": 5, "repeatTimes": 2],
        ["type": "fundsClose", "label": "基金收盘", "remindTime": "14:55", "repeatInterval": 1, "repeatTimes": 4]
    ]],
    ["type": "festival", "label": "特殊节日提醒", "important": 1, "repeatType": 5, "subTypes": [
        ["type": "tradition", "label": "传统节日"],
        ["type": "shopping", "label": "购物节"],
        ["type": "valentine", "label": "情人节", "remindMonth": 2, "remindDay": 13],
        ["type": "woman", "label": "女王节", "remindMonth": 3, "remindDay": 7],
        ["type": "mather", "label": "母亲节", "remindMonth": 5, "remindWeekDay": 1],
        ["type": "father", "label": "父亲节", "remindMonth": 6, "remindWeekDay": 1],
        ["type": "children", "label": "儿童节", "remindMonth": 5, "remindDay": 31],
        ["type": "teacher", "label": "教师节", "remindMonth": 9, "remindDay": 9]
    ]]
]
let ALARM_REPEAT_TYPES: [String] = ["仅一次", "工作日", "每天", "每周", "每月", "每年", "交易日"]
let ALARM_IMPORTANT_LEVELS = [
    ["label": "普通", "repeatTimes": 1],
    ["label": "重要", "repeatTimes": 3, "repeatInterval": 5],
    ["label": "非常重要", "repeatTimes": 10, "repeatInterval": 5],
    ["label": "自定义", "repeatTimes": 3, "repeatInterval": 5]
]

let ALARM_SOUNDS: [String] = ["默认", "a2"]
