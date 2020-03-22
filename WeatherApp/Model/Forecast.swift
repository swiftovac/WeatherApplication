//
//  Forecast.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 17/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import Foundation



class Forecast {
    
    var _date: String!
    var _weatherDesc: String!
 
    var _maxTemp: Double!
    var _hour: String!
    
    var hour: String {
        if _hour == nil {
            _hour = ""
        }
        
        return _hour
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        return _date
    }
    
    var weatherDescription: String{
        if _weatherDesc == nil {
            _weatherDesc = ""
        }
        return _weatherDesc
    }
    
    var maxTemp: Double {
        if _maxTemp == nil {
            _maxTemp = 0.0
        }
        
        return _maxTemp
    }
    
}
