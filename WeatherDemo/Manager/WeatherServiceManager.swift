//
//  WeatherServiceManager.swift
//  WeatherDemo
//
//  Created by Dany on 5/16/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

struct WeatherConditions {
    var city: String
    var temperatureCelsius: Double
    var humidityPercent: Int
    var generalDescription: String
}

enum WeatherResult {
    case Success(WeatherConditions)
    case Error(String)
}

fileprivate let API_KEY = "51174bce8f4a02feb1551c3b7485e95a"
fileprivate let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

class WeatherServiceManager {
    
    func weather(forCity city: String, completionHandler: @escaping (WeatherResult) -> Void) {
        let escapedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "\(BASE_URL)?q=\(escapedCity)&appid=\(API_KEY)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.Error(error.localizedDescription))
                return
            }
            guard let data = data else {
                completionHandler(.Error("No data received"))
                return
            }
            completionHandler(self.weather(fromJsonData: data))
        }
        task.resume()
    }
    
    func weather(forCoordinate lat: String, lon: String, completionHandler: @escaping (WeatherResult) -> Void) {
        let url = URL(string: "\(BASE_URL)?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.Error(error.localizedDescription))
                return
            }
            guard let data = data else {
                completionHandler(.Error("No data received"))
                return
            }
            completionHandler(self.weather(fromJsonData: data))
        }
        task.resume()
    }

    func weather(fromJsonData data: Data) -> WeatherResult {
        let raw = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let json = raw as? [String: AnyObject],
              let city = json["name"] as? String,
            
              let weather = json["weather"] as? [AnyObject],
              let descriptionObj = weather[0] as? [String: AnyObject],
              let description = descriptionObj["description"] as? String,
            
              let main = json["main"],
              let temperature = main["temp"] as? Double,
              let humidity = main["humidity"] as? Int
        else {
            return .Error("Malformed JSON response")
        }
        func celsiusFromKelvin(kelvin: Double) -> Double {
            return kelvin - 273.15
        }
        return .Success(WeatherConditions(city: city,
                                          temperatureCelsius: celsiusFromKelvin(kelvin: temperature),
                                          humidityPercent: humidity,
                                          generalDescription: description))
    }
    
}
