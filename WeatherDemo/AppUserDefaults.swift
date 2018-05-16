//
//  AppUserDefaults.swift
//  WeatherDemo
//
//  Created by Dany on 5/16/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import CoreLocation

fileprivate let LAST_LAT_KEY = "dany_weather_demo.last_lat"
fileprivate let LAST_LON_KEY = "dany_weather_demo.last_lon"
fileprivate let LAST_CITY_KEY = "dany_weather_demo.last_city"
fileprivate let LAST_WEATHER_MAIN_KEY = "dany_weather_demo.last_weather_info_main"
fileprivate let LAST_WEATHER_SUB_KEY = "dany_weather_demo.last_weather_info_sub"

class AppUserDefaults {

    func lastLatitude() -> String? {
        return UserDefaults.standard.string(forKey: LAST_LAT_KEY)
    }
    
    func lastLongitude() -> String? {
        return UserDefaults.standard.string(forKey: LAST_LON_KEY)
    }
    
    func lastCity() -> String? {
        return UserDefaults.standard.string(forKey: LAST_CITY_KEY)
    }
    
    func lastWeatheInfoMain() -> String? {
        return UserDefaults.standard.string(forKey: LAST_WEATHER_MAIN_KEY)
    }
    
    func lastWeatheInfoMainSub() -> String? {
        return UserDefaults.standard.string(forKey: LAST_WEATHER_SUB_KEY)
    }
    
    func saveLastCity(_ city: String) {
        UserDefaults.standard.setValue(city, forKey: LAST_CITY_KEY)
        UserDefaults.standard.synchronize()
    }

    func saveLastLatitude(_ lat: String) {
        UserDefaults.standard.setValue(lat, forKey: LAST_LAT_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func saveLastLongitude(_ lon: String) {
        UserDefaults.standard.setValue(lon, forKey: LAST_LON_KEY)
        UserDefaults.standard.synchronize()
    }

    func saveLastWeatherMain(_ mainWeather: String) {
        UserDefaults.standard.setValue(mainWeather, forKey: LAST_WEATHER_MAIN_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func saveLastWeatherSub(_ subWeather: String) {
        UserDefaults.standard.setValue(subWeather, forKey: LAST_WEATHER_SUB_KEY)
        UserDefaults.standard.synchronize()
    }

}
