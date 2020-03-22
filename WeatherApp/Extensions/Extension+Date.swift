//
//  Extension+Date.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 17/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import Foundation

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func hourFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    
    
}
