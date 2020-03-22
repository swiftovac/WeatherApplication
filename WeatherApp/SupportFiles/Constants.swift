//
//  Constants.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 16/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import Foundation


let kWeatheCellIdentifier = "WeatherCell"

let API_KEY = "48926cde832f103ad4f1136efab50407"
let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let FORECAST_BASE_URL = "http://api.openweathermap.org/data/2.5/"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let FORECAST = "forecast?"
let CURRENT_WHEATER_URL = "\(BASE_URL)\(LATITUDE)\(Location.sharedInstance.latitude)\(LONGITUDE)\(Location.sharedInstance.longitude)\(APP_ID)\(API_KEY)"
let FORECAST_URL = "\(FORECAST_BASE_URL)\(FORECAST)\(LATITUDE)\(Location.sharedInstance.latitude)\(LONGITUDE)\(Location.sharedInstance.longitude)\(APP_ID)\(API_KEY)"





//https://api.openweathermap.org/data/2.5/forecast?lat=51.5074&lon=0.1278&appid=48926cde832f103ad4f1136efab50407
