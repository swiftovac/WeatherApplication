//
//  ViewController.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 15/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainVC: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var wheaterImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather = CurrentWeather()
    var forecast = Forecast()
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: kWeatheCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        getCurrnetWeatherData(url: CURRENT_WHEATER_URL)
        getFiveDaysForecastData(url: FORECAST_URL)
        
    }
    
    
    
    
    func getCurrnetWeatherData(url: String) {
        AF.request(url).responseJSON {
            response in
            
            if response.response?.statusCode == 200 {
                print("Ajde bre")
                let weatherJSON: JSON = JSON(response.value!)
                self.parseCurrentWeatherJSON(json: weatherJSON)
                // here save response in core data
            }else {
                print("There is some error")
                // here load offline data
            }
            
        }
        
    }
    
    func parseCurrentWeatherJSON(json: JSON) {
        
        if let temperature = json["main"]["temp"].double {
            
            let temp = Int(temperature - 273)
            let cityName = json["name"].stringValue
            let weatherDesc = json["weather"][0]["main"].stringValue
            
            currentWeather._cityName = cityName
            currentWeather._currentTemp = temp
            currentWeather._weatherDescription = weatherDesc
            
            updateUIWithWeatherData()
        }else {
            print("There is some error")
            
        }
    }
    
    
    func getFiveDaysForecastData(url: String) {
        
        AF.request(url).responseJSON{
            response in
            
            if response.response?.statusCode == 200 {
                let forecastJSON: JSON = JSON(response.value!)
                self.parseFiveDaysForecastJSON(json: forecastJSON)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
               
            }else {
                print("Error fetching forecast data")
            }
            
        }
        
        
    }
    
    func parseFiveDaysForecastJSON(json: JSON) {
                
        if let list = json["list"].array {
            
            for item in list {
                if let date = item["dt"].double {
                    
                    let unixConvertedDate = Date(timeIntervalSince1970: date)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .full
                    dateFormatter.dateFormat = "EEEE"
                    dateFormatter.timeStyle = .none
                    
                    forecast._date = unixConvertedDate.dayOfTheWeek()
                }
                
                if let main = item["main"].dictionary {
                    if let minTemp = main["temp_min"]?.double {
                        forecast._minTemp = "\(minTemp)"
                    }
                    
                    if let maxTemp = main["temp_max"]?.double {
                        forecast._maxTemp = "\(maxTemp)"
                    }
                }
                
                if let weatherDesc = item["weather"][0]["main"].string {
                    forecast._weatherDesc = weatherDesc
                }
                
              
                if !checkIfDayIsInArray(forecastsArray: forecasts, day: forecast._date) {
                    forecasts.append(forecast)
                    forecast = Forecast()
                }
                
            }
            
            print("Evo ga arr === \(forecasts)")
            
        }

    }
    
    
    func updateUIWithWeatherData() {
        cityNameLabel.text = currentWeather.cityName
        weatherDescLabel.text = currentWeather.weatherDescription
        wheaterImageView.image = UIImage(named: currentWeather.weatherDescription)
        tempLabel.text = "\(currentWeather.currentTemp)°"
        dayLabel.text = currentWeather.date
        
    }
    
    func checkIfDayIsInArray(forecastsArray: [Forecast], day: String) -> Bool {
        for item in forecastsArray {
            if item._date == day {
                return true
            }
        }
        
        return false
    }
    
}


// MARK: - TableViewDelegate & TableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:kWeatheCellIdentifier, for: indexPath) as! WeatherCell
        let forecast = forecasts[indexPath.row]
        cell.configureUIWithForecastData(forecast: forecast)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

