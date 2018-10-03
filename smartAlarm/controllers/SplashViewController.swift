//
//  SplashViewController.swift
//  smartAlarm
//
//  Created by linkage on 2018/9/9.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class SplashViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var enterBtn: UIButton!
    let locationManager: CLLocationManager = CLLocationManager()
    var isLocated = false
    var keywords: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        Thread.sleep(forTimeInterval: 2)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
//        self.present(mainViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        
//        Thread.sleep(forTimeInterval: 2)
        enableLocation()
        var seconds = 3
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if seconds < 0 {
                self.enterBtn.sendActions(for: .touchUpInside)
                timer.invalidate()
            } else {
                self.enterBtn.titleLabel?.text = "进入(\(seconds))"
                seconds = seconds - 1
            }
//            print(self.enterBtn.titleLabel?.text)
        }
    }
    
    func enableLocation() {
        locationManager.delegate = self
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        //发出授权请求
        locationManager.requestWhenInUseAuthorization()

        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isLocated {
            isLocated = true
            //获取最新的坐标
            let currLocation: CLLocation = locations.last!  // 持续更新
            let adjustLocation = LocationUtils.transformFromWGSToBd09(loc: currLocation.coordinate)
            // 获取经纬度
            print("纬度:\(currLocation.coordinate.latitude)")
            print("经度:\(currLocation.coordinate.longitude)")
            print("调整纬度:\(adjustLocation.latitude)")
            print("调整经度:\(adjustLocation.longitude)")
            //获得海拔
            print("海拔:\(currLocation.altitude)")
            //获取水平精度
            print("水平精度:\(currLocation.horizontalAccuracy)")
            //获取垂直精度
            print("垂直精度:\(currLocation.verticalAccuracy)")
            //获取方向
            print("方向:\(currLocation.course)")
            //获取速度
            print("速度:\(currLocation.speed)")
            locationManager.stopUpdatingLocation()
            print("定位结束")
            //            getWeather(location: "\(currLocation.coordinate.latitude),\(currLocation.coordinate.longitude)")
            parseDateToKeywords(
                latitude: "\(adjustLocation.latitude)",
                longitude: "\(adjustLocation.longitude)",
                altitude: "\(currLocation.altitude)",
                speed: "\(currLocation.speed)"
            )
        }
    }
    
    func getWeather(location: String) {
        print("getWeather::enter")
        Alamofire.request(
            "http://api.jisuapi.com/weather/query",
            method: .get,
            parameters: ["appkey": DATA_APP_KEY, "location": location],
            encoding: URLEncoding.default
            ).responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    let dict = json as! Dictionary<String, Any>
                    if dict["msg"] as! String == "ok" {
                        let wetherResult = dict["result"] as! Dictionary<String, Any>
                        let wether = Wether(
                            city: wetherResult["city"] as! String,
                            cityid: wetherResult["cityid"] as! String,
                            citycode: wetherResult["citycode"] as! String,
                            wether: wetherResult["wether"] as! String,
                            temp: wetherResult["temp"] as! String,
                            templow: wetherResult["templow"] as! String,
                            temphigh: wetherResult["temphigh"] as! String,
                            humidity: wetherResult["humidity"] as! String,
                            windpower: wetherResult["windpower"] as! String
                        )
                        let keywords = self.parseWetherToKeywords(wether: wether.wether, temp: wether.temp, windPower: wether.windpower, humidity: wether.humidity)
                        self.getRecommendPoems(keywords: keywords)
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        locationManager.stopUpdatingLocation()
        print("getWeather::end")
    }
    
    func parseDateToKeywords(latitude: String, longitude: String, altitude: String, speed: String) {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timestamp = CLongLong(round(timeInterval * 1000))
        Alamofire.request(
            "\(host)/getDateInfo",
            method: .post,
            parameters: ["timestamp": "\(timestamp)", "latitude": latitude, "longitude": longitude, "altitude": altitude, "speed": speed],
            encoding: JSONEncoding.default
            ).responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    let dict = json as! Dictionary<String, Any>
                    if dict["status"] as! String == "success" {
                        let data = dict["data"] as! Dictionary<String, Any>
                        let lunarDay = data["lunarDay"] as! Dictionary<String, Any>
                        let season = data["season"] as! String
                        let datePeriod = data["datePeriod"] as! [String]
                        let locationData = data["locationData"] as! Dictionary<String, Any>
                        
                        print(lunarDay, season, datePeriod, locationData)
                        // 农历节日
//                        let lunarFestival = data["lunarFestival"] as? String;
//                        if lunarFestival != nil {
//                            self.keywords.append(lunarFestival!)
//                        }
//
//                        // 阳历节日
//                        let solarFestival = data["solarFestival"] as? String;
//                        if solarFestival != nil {
//                            self.keywords.append(solarFestival!)
//                        }
//
//                        // 节气
//                        let term = data["term"] as? String;
//                        if term != nil {
//                            self.keywords.append(term!)
//                        }
//
//                        print("keywords", self.keywords)
//                        self.getRecommendPoems(keywords: self.keywords)
                    } else {
                        print(json)
                    }
                case .failure(let error):
                    print("\(error)")
                }
        }
    }
    
    func parseWetherToKeywords(wether: String, temp: String, windPower: String, humidity: String) -> [String] {
        var keywords: [String] = []
        let _temp = Int(temp)
        let _windPower = Int(temp)
        let _numidity = Int(humidity)
        
        // 温度
        if _temp != nil {
            if _temp! >= 28 {
                keywords.append("热")
                if _temp! >= 35 {
                    keywords.append("三伏")
                }
            } else if (_temp! < 5) {
                keywords.append("冷")
                if _temp! < 0 {
                    keywords.append("冰")
                }
            }
        }
        
        // 天气
        keywords.append(wether)
        
        return keywords
    }
    
    func getRecommendPoems(keywords: [String]) {
        Alamofire.request(
            "\(host)/searchPoems",
            method: .post,
            parameters: ["keywords": keywords],
            encoding: JSONEncoding.default
            ).responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    let dict = json as! Dictionary<String, Any>
//                    print("dict", dict)
                    if dict["status"] as! String == "success" {
                        let data = dict["data"] as! Dictionary<String, Any>
                        let poem = data["poem"] as! Dictionary<String, Any>
                        print(poem)
                    }
                case .failure(let error):
                    print("\(error)")
                }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位出错！\(error)")
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
