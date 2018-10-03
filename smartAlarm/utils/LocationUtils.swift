//
//  LocationUtils.swift
//  smartAlarm
//
//  Created by linkage on 2018/10/3.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation
import CoreLocation

class LocationUtils {
    static let a = 6378245.0
    static let ee = 0.00669342162296594323
    static let pi = 3.14159265358979324
    static let x_pi = 3.14159265358979324 * 3000.0 / 180.0
    static func isLocationOutOfChina(location: CLLocationCoordinate2D) -> Bool {
        if (location.longitude < 72.004 || location.longitude > 137.8347) {
            return true
        }
        if location.latitude < 0.8293 || location.latitude > 55.8271 {
            return true
        }
        return false;
    }
    
    static func transformLat(x: Double, y: Double) -> Double {
        var lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x))
        lat += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
        lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0
        return lat
    }
    
    static func transformLon(x: Double, y: Double) -> Double {
        var lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x))
        lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
        lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
        return lon
    }
    
    static func transformFromWGSToGCJ(loc: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var adjustLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
        if isLocationOutOfChina(location: loc) {
            adjustLoc = loc;
        } else {
            var adjustLat: Double = transformLat(x: loc.longitude - 105.0, y: loc.latitude - 35.0)
            var adjustLon: Double = transformLon(x: loc.longitude - 105.0, y: loc.latitude - 35.0)
            let radLat: Double = loc.latitude / 180.0 * pi
            var magic: Double = sin(radLat)
            magic = 1 - ee * magic * magic
            let sqrtMagic: Double = sqrt(magic)
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
            adjustLoc.latitude = loc.latitude + adjustLat
            adjustLoc.longitude = loc.longitude + adjustLon
        }
        return adjustLoc
    }
    
    static func transformFromGCJToBd09(loc: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var adjustLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lon = loc.longitude
        let lat = loc.latitude
        let z = sqrt(lon * lon + lat * lat) + 0.00002 * sin(lat * x_pi)
        let theta = atan2(lat, lon) + 0.000003 * cos(lon * x_pi)
        let tempLon = z * cos(theta) + 0.0065
        let tempLat = z * sin(theta) + 0.006
        adjustLoc.latitude = tempLat
        adjustLoc.longitude = tempLon
        return adjustLoc
    }
    
    static func transformFromWGSToBd09(loc: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return transformFromGCJToBd09(loc: transformFromWGSToGCJ(loc: loc))
    }
}
