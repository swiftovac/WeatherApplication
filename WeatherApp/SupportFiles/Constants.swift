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
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let CURRENT_WHEATER_URL = "\(BASE_URL)\(LATITUDE)51.5074\(LONGITUDE)0.1278\(APP_ID)\(API_KEY)"




