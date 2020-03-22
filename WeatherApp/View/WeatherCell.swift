//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 16/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    
    @IBOutlet weak var wheaterImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!

    
    @IBOutlet var hourLabels: [UILabel]!
    @IBOutlet var tempLbls: [UILabel]!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for lbls in tempLbls {
            lbls.text = ""
        }
        
        for lbl in hourLabels {
            lbl.text = ""
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for lbls in tempLbls {
            lbls.text = ""
        }
        
        for lbl in hourLabels {
            lbl.text = ""
        }
    }
    
    func configureUIWithForecastData(forecast: Forecast) {
        wheaterImageView.image = UIImage(named: forecast.weatherDescription)
        weatherDescLabel.text = forecast.weatherDescription
        dayLabel.text = forecast.date
      
    }
    
    func configureCellWithForecastModel(forecast: ForecastModel){
        wheaterImageView.image = UIImage(named: forecast.weatherDescription!)
        weatherDescLabel.text = forecast.weatherDescription!
        dayLabel.text = forecast.date!
    }
    
    func configureUIWithHourlyData(forecasts: [Forecast]){
        var maxTemps = [Int]()
        var hours = [Int]()
        for forec in forecasts {
            let maxtemp = Int(forec.maxTemp - 273)
            let hour = Int(forec.hour)
            maxTemps.append(maxtemp)
            hours.append(hour! - 1)
        }
        
        
        for index in 0..<maxTemps.count {
            tempLbls[index].text = "\(maxTemps[index])°"
            if hours[index] < 10 {
                hourLabels[index].text = "0\(hours[index])"
            }
            else {
                hourLabels[index].text = "\(hours[index])"
            }
        }
        
        maxTemps = [Int]()
        hours = [Int]()
        
    }
    
    func configureCellWithOfflineHourlyData(forecasts: [HourlyModel]) {
        var maxTemps = [Int]()
        var hours = [Int]()
        
        for forecast in forecasts {
            let maxTemp = Int(forecast.maxTemp - 273)
            let hour = Int(forecast.hour!)
            maxTemps.append(maxTemp)
            hours.append(hour! - 1)
            
        }
        
        for index in 0..<maxTemps.count {
            tempLbls[index].text = "\(maxTemps[index])°"
            if hours[index] < 10 {
                hourLabels[index].text = "0\(hours[index])"
            }
            else {
                hourLabels[index].text = "\(hours[index])"
            }
        }
        
        maxTemps = [Int]()
        hours = [Int]()
        
        
    }
    
}
