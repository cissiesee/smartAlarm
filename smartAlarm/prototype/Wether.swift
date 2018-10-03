//
//  Wether.swift
//  smartAlarm
//
//  Created by linkage on 2018/8/17.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation

class Wether: NSObject {
    var city: String = ""
    var cityid: String = ""
    var citycode: String = ""
    var wether: String = ""
    var temp: String = ""
    var templow: String = ""
    var temphigh: String = ""
    var humidity: String = ""
    var windpower: String = ""
    
    init(city: String, cityid: String, citycode: String, wether: String, temp: String, templow: String, temphigh: String, humidity: String, windpower: String) {
        self.city = city
        self.cityid = cityid
        self.citycode = citycode
        self.wether = wether
        self.temp = temp
        self.templow = templow
        self.temphigh = temphigh
        self.humidity = humidity
        self.windpower = windpower
        super.init()
    }
}
