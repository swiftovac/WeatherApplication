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
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.contentView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureUIWithForecastData(forecast: Forecast) {
        wheaterImageView.image = UIImage(named: forecast.weatherDescription)
        weatherDescLabel.text = forecast.weatherDescription
        dayLabel.text = forecast.date
        maxTempLabel.text = forecast.maxTemp
        minTempLabel.text = forecast.minTemp
    }
    
    
    
}
