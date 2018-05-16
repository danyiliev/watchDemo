//
//  WeatherViewController.swift
//  WeatherDemo
//
//  Created by Dany on 5/16/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var cityLabel: UILabel!

    private let userDefaults = AppUserDefaults()
    private var results = [WeatherResult]()

    var coordinateLoc: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let latString = "\(coordinateLoc.latitude)"
        let lonString = "\(coordinateLoc.longitude)"
        self.getWeather(latitude: latString, longitude: lonString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let lastlat = userDefaults.lastLatitude(), let lastlon = userDefaults.lastLongitude() {
            self.getWeather(latitude: lastlat, longitude: lastlon)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Internal methods
    
    private func getWeather(latitude: String, longitude: String) {
        WeatherServiceManager().weather(forCoordinate: latitude, lon: longitude, completionHandler: { (result) in
            DispatchQueue.main.async {
                self.processResult(result: result)
            }
            
            self.userDefaults.saveLastLatitude(latitude)
            self.userDefaults.saveLastLongitude(longitude)
        })
        
    }
    
    private func processResult(result: WeatherResult) {
        if case .Error(_) = result {
            let alert = UIAlertController(title: "Warning", message: "The app is working on offline mode. This is the weather data of the previous location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        results.removeAll()
        results.append(result)
        self.resultsTable.reloadData()
    }

}

// MARK: -

extension WeatherViewController: UITableViewDataSource {
    
    // MARK: TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "result_cell", for: indexPath)

        let result = results[indexPath.row]
        switch result {
        case .Error(let error):
            cell.textLabel?.text = "Error"
            cell.detailTextLabel?.text = error
            
            cell.textLabel?.text = userDefaults.lastWeatheInfoMain()
            cell.detailTextLabel?.text = userDefaults.lastWeatheInfoMainSub()
            self.cityLabel.text = userDefaults.lastCity()
        case .Success(let conditions):
            let formattedTemperature = String(format: "%.2f", conditions.temperatureCelsius)
            cell.textLabel?.text = "\(conditions.generalDescription.capitalized) in \(conditions.city)"
            cell.detailTextLabel?.text = "\(formattedTemperature)℃, \(conditions.humidityPercent)% humidity"
            self.cityLabel.text = conditions.city
            
            userDefaults.saveLastWeatherSub((cell.detailTextLabel?.text)!)
            userDefaults.saveLastWeatherMain((cell.textLabel?.text)!)
            userDefaults.saveLastCity(conditions.city)
        }
        return cell
    }

}
