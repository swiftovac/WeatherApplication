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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
