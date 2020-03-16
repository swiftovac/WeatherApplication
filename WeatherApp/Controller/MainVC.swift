//
//  ViewController.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 15/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var wheaterImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: kWeatheCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }


}


// MARK: - TableViewDelegate & TableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:kWeatheCellIdentifier, for: indexPath) as! WeatherCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

