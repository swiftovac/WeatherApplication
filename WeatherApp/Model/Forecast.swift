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
    var _minTemp: String!
    var _maxTemp: String!
    
    
//    init(date: String, weatherDesc: String, minTemp:String, maxTemp:String) {
//        _date = date
//        _weatherDesc = weatherDesc
//        _minTemp = minTemp
//        _maxTemp = maxTemp
//    }
    
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
    
    
    var minTemp: String  {
        if _minTemp == nil {
            _minTemp = ""
        }
        
        return _minTemp
    }
    
    
    var maxTemp: String {
        if _maxTemp == nil {
            _maxTemp = ""
        }
        
        return _maxTemp
    }
    

    
}
