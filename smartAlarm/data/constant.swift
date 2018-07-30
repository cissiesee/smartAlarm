//
//  constant.swift
//  smartAlarm
//
//  Created by linkage on 2018/5/18.
//  Copyright © 2018年 hzt. All rights reserved.
//

let host = "http://192.168.1.166:5000/"

let ALARM_TYPES = [
    ["type": "morning", "info": "起床了，早安", "important": 2, "repeatType": 1],
    ["type": "repay", "info": "还贷提醒", "important": 2, "repeatType": 4],
    ["type": "birthday", "info": "生日提醒", "important": 1, "repeatType": 5],
    ["type": "festival", "info": "特殊节日提醒", "important": 1, "repeatType": 5]
]
let REPAY_TYPES = [
    ["type": "house_loan", "label": "房贷"],
    ["type": "ant_huabei", "label": "蚂蚁花呗", "repayDay": 9, "remindDay": 8],
    ["type": "jingdong_baitiao", "label": "京东白条", "repayDay": 15, "remindDay": 13],
    ["type": "suning_renxingfu", "label": "苏宁任性付", "repayDay": 15, "remindDay": 13],
    ["type": "credit_card", "label": "信用卡"]
]
let FESTIVAL_TYPES = [
    ["type": "tradition", "label": "传统节日"],
    ["type": "shopping", "label": "购物节"],
    ["type": "valentine", "label": "情人节"],
    ["type": "woman", "label": "女王节"],
    ["type": "mather", "label": "母亲节"],
    ["type": "father", "label": "父亲节"],
    ["type": "children", "label": "儿童节"],
    ["type": "teacher", "label": "教师节"]
]
let ALARM_REPEAT_TYPES: [String] = ["仅一次", "工作日", "每天", "每周", "每月", "每年"]
let ALARM_IMPORTANT_LEVELS: [String] = ["普通(不重复提醒)", "重要(默认提醒3次)", "非常重要(默认提醒10次)"]
