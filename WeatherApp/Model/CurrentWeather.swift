//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 16/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class CurrentWeather {
    
    var _cityName: String!
    var _weatherDescription: String!
    var _currentTemp: Int!
    var _date: String!
    
    var cityName: String{
        if _cityName == nil {
            _cityName = ""
        }
        
        return _cityName
    }
    
    var weatherDescription: String {
        if _weatherDescription == nil {
            _weatherDescription = ""
        }
        
        return _weatherDescription
    }
    
    var currentTemp: Int {
        if _currentTemp == nil {
            _currentTemp = 0
            
        }
        return _currentTemp
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "TODAY, \(currentDate)"
        
        return _date
    }
    
}
