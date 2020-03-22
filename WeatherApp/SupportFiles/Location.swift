//
//  Location.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 19/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//


import CoreLocation


class Location {
    static var sharedInstance = Location()
    
    private init() {
        
    }
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    
}
