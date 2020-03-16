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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: kWeatheCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        getCurrnetWeatherData(url: CURRENT_WHEATER_URL)
        
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
    
    
    func updateUIWithWeatherData() {
        cityNameLabel.text = currentWeather.cityName
        weatherDescLabel.text = currentWeather.weatherDescription
        wheaterImageView.image = UIImage(named: currentWeather.weatherDescription)
        tempLabel.text = "\(currentWeather.currentTemp)°"
        dayLabel.text = currentWeather.date
        
    }
    
    
}


// MARK: - TableViewDelegate & TableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:kWeatheCellIdentifier, for: indexPath) as! WeatherCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

