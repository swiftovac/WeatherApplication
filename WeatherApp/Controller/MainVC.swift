//
//  ViewController.swift
//  WeatherApp
//
//  Created by Stefan Milenkovic on 15/03/2020.
//  Copyright © 2020 Stefan Milenkovic. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import CoreData


class MainVC: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var wheaterImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentWeather = CurrentWeather()
    var forecast = Forecast()
    var forecasts = [Forecast]()
    var helperArray = [Forecast]()
    var allForecasts = [[Forecast]]()
    var fetchedOfflineCurrentWeather: [CurrentWeatherModel]?
    
    
    var forecastModels = [ForecastModel]()
    var allForecastsModels = [[ForecastModel]]()
    var hourlyModels = [HourlyModel]()
    var hourlyHelperArray = [HourlyModel]()
    var allHourlyModels = [[HourlyModel]]()
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: kWeatheCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if forecasts.count == 0 {
            loadForecastData()
        }
        if allForecasts.count == 0 {
            loadHourlyData()
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Api handling Functions
    
    
    func getCurrnetWeatherData(url: String) {
        AF.request(url).responseJSON {
            response in
            
            if response.response?.statusCode == 200 {
                let weatherJSON: JSON = JSON(response.value!)
                self.parseCurrentWeatherJSON(json: weatherJSON)
                
            }else {
                
                // call this when user have cached data but it's offline or api server not work
                self.loadCurrentWeather()
                
                self.activityIndicator.stopAnimating()
                if self.fetchedOfflineCurrentWeather != nil && self.fetchedOfflineCurrentWeather?.count != 0 {
                    self.cityNameLabel.text = self.fetchedOfflineCurrentWeather?[0].cityName
                    self.weatherDescLabel.text = self.fetchedOfflineCurrentWeather?[0].weatherDescription
                    self.tempLabel.text = "\(self.fetchedOfflineCurrentWeather![0].currentTemp)°"
                    self.wheaterImageView.image = UIImage(named: self.fetchedOfflineCurrentWeather![0].weatherDescription!)
                    self.dayLabel.text = "You are offline, this is cached data"
                    
                }else {
                    // call this if user start app for the first time and don't have internet connection
                    self.activityIndicator.stopAnimating()
                    self.cityNameLabel.text = "You are offline"
                    self.weatherDescLabel.text = ""
                    self.tempLabel.text = ""
                    self.wheaterImageView.image = UIImage()
                    self.dayLabel.text = "Check your connection, then try again"
                    
                }
            }
        }
        
    }
    
    func parseCurrentWeatherJSON(json: JSON) {
        
        if let temperature = json["main"]["temp"].double {
            
            let temp = Int(temperature - 273)
            let cityName = json["name"].stringValue
            let weatherDesc = json["weather"][0]["main"].stringValue
            
            currentWeather._cityName = cityName
            currentWeather._currentTemp = temp
            currentWeather._weatherDescription = weatherDesc
            
            deleteAllCurrentWeatherFromDatabase()
            
            let currWeather = CurrentWeatherModel(context: context)
            currWeather.cityName = cityName
            currWeather.weatherDescription = weatherDesc
            currWeather.currentTemp = Int32(temp)
            currWeather.date = "moj datum"
            
            saveCurrentWeather()
            
            updateUIWithWeatherData()
            
        }else {
            print("Error parsing current weather data")
            
        }
    }
    
    
    func getFiveDaysForecastData(url: String) {
        
        AF.request(url).responseJSON{
            response in
            
            if response.response?.statusCode == 200 {
                let forecastJSON: JSON = JSON(response.value!)
                self.parseFiveDaysForecastJSON(json: forecastJSON)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                
            }else {
                
                self.loadHourlyData()
                self.loadForecastData()
                
                print("Error fetching forecast data")
            }
            
        }
    }
    
    func parseFiveDaysForecastJSON(json: JSON) {
        
        
        if let list = json["list"].array {
            
            deleteAllForecastFromDatabase()
            deleteAllHourlyDataFromDatabase()
            
            for item in list {
                if let date = item["dt"].double {
                    
                    let unixConvertedDate = Date(timeIntervalSince1970: date)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .full
                    dateFormatter.dateFormat = "EEEE"
                    dateFormatter.timeStyle = .long
                    
                    forecast._date = unixConvertedDate.dayOfTheWeek()
                    forecast._hour = unixConvertedDate.hourFromDate()
                    
                }
                
                if let main = item["main"].dictionary {
                    
                    if let maxTemp = main["temp_max"]?.double {
                        forecast._maxTemp = maxTemp
                        
                    }
                }
                
                if let weatherDesc = item["weather"][0]["main"].string {
                    forecast._weatherDesc = weatherDesc
                    
                }
                
                if !checkIfDayIsInArray(forecastsArray: helperArray, day: forecast._date) ||  item == list.last {
                    if item == list.last {
                        helperArray.append(forecast)
                        
                    }
                    if helperArray.count != 0 {
                        allForecasts.append(helperArray)
                        
                        
                    }
                    helperArray = [Forecast]()
                    helperArray.append(forecast)
                    
                    
                }else {
                    helperArray.append(forecast)
                }
                
                if !checkIfDayIsInArray(forecastsArray: forecasts, day: forecast._date) {
                    forecasts.append(forecast)
                    
                    
                    forecast = Forecast()
                    
                    
                }else {
                    forecast = Forecast()
                    
                }
            }
            
            saveForecastData(forecasts: forecasts)
            saveHourlyData(forecasts: allForecasts)
        }
        
    }
    
    // MARK: Functions for Core Data
    
    func saveCurrentWeather() {
        do {
            try context.save()
            print("Current weather cached")
        }catch {
            print("Error saving context")
        }
    }
    
    func loadCurrentWeather() {
        let request: NSFetchRequest<CurrentWeatherModel> = CurrentWeatherModel.fetchRequest()
        
        do {
            fetchedOfflineCurrentWeather =  try context.fetch(request)
        }catch{
            print("Error fetching data from database")
        }
        
    }
    
    func deleteAllForecastFromDatabase() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ForecastModel")
        
        do {
            let results = try context.fetch(request)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! ForecastModel
                context.delete(managedObjectData)
            }
            
            do {
                try context.save()
            }catch{
                print("Error saving context")
            }
        }catch {
            
            print("Error deleteing objects")
        }
        
    }
    
    func deleteAllHourlyDataFromDatabase() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HourlyModel")
        
        do {
            let results = try context.fetch(request)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! HourlyModel
                context.delete(managedObjectData)
            }
            
            do {
                try context.save()
            }catch{
                print("Error saving context")
            }
        }catch {
            
            print("Error deleteing objects")
        }
        
    }
    
    func deleteAllCurrentWeatherFromDatabase() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentWeatherModel")
        
        do {
            let results = try context.fetch(request)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! CurrentWeatherModel
                context.delete(managedObjectData)
            }
            
            do {
                try context.save()
            }catch{
                print("Error saving context")
            }
        }catch {
            
            print("Error deleteing objects")
        }
        
    }
    
    func loadForecastData() {
        
        let request: NSFetchRequest<ForecastModel> = ForecastModel.fetchRequest()
        
        do {
            forecastModels =  try context.fetch(request)
        }catch{
            print("Error fetching data from database")
        }
        
    }
    
    func loadHourlyData() {
        let request: NSFetchRequest<HourlyModel> = HourlyModel.fetchRequest()
        
        do {
            hourlyModels = try context.fetch(request)
            for item in hourlyModels {
                if !checkForOfflineArrays(forecastsArray: hourlyHelperArray, day: item.date!) ||  item == hourlyModels.last {
                    if item == hourlyModels.last {
                        hourlyHelperArray.append(item)
                        
                    }
                    if hourlyHelperArray.count != 0 {
                        allHourlyModels.append(hourlyHelperArray)
                        
                        
                    }
                    hourlyHelperArray = [HourlyModel]()
                    hourlyHelperArray.append(item)
                    
                    
                }else {
                    hourlyHelperArray.append(item)
                }
            }
            
        }catch{
            print("Error fetching data from database")
        }
    }
    
    func saveForecastData(forecasts: [Forecast]) {
        for forecast in forecasts {
            let forecastModel = NSEntityDescription.insertNewObject(forEntityName: "ForecastModel", into: context)
            forecastModel.setValue(forecast._date, forKey: "date")
            forecastModel.setValue(forecast.maxTemp, forKey: "maxTemp")
            forecastModel.setValue(forecast.hour, forKey: "hour")
            forecastModel.setValue(forecast.weatherDescription, forKey: "weatherDescription")
            do {
                try context.save()
                
            }catch{
                print("Error savin forecasts data")
            }
        }
    }
    
    func saveHourlyData(forecasts: [[Forecast]]) {
        for item in forecasts {
            for forecast in item {
                
                let hourlyModel = NSEntityDescription.insertNewObject(forEntityName: "HourlyModel", into: context)
                hourlyModel.setValue(forecast._date, forKey: "date")
                hourlyModel.setValue(forecast.maxTemp, forKey: "maxTemp")
                hourlyModel.setValue(forecast.hour, forKey: "hour")
                
                do {
                    try context.save()
                    
                }catch{
                    print("Error savin forecasts data")
                }
                
            }
        }
    }
    
    
    func updateUIWithWeatherData() {
        cityNameLabel.text = currentWeather.cityName
        weatherDescLabel.text = currentWeather.weatherDescription
        wheaterImageView.image = UIImage(named: currentWeather.weatherDescription)
        tempLabel.text = "\(currentWeather.currentTemp)°"
        dayLabel.text = currentWeather.date
        activityIndicator.stopAnimating()
        
    }
    
    // MARK: - Helper functions
    
    func checkIfDayIsInArray(forecastsArray: [Forecast], day: String) -> Bool {
        for item in forecastsArray {
            if item._date == day {
                return true
            }
        }
        
        return false
    }
    
    func checkForOfflineArrays(forecastsArray: [HourlyModel], day: String) -> Bool {
        for item in forecastsArray {
            if item.date == day {
                return true
            }
        }
        
        return false
    }
    
}


// MARK: - TableViewDelegate & TableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forecasts.count != 0 {
            return forecasts.count
        }else {
            return forecastModels.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:kWeatheCellIdentifier, for: indexPath) as! WeatherCell
        
        if forecasts.count != 0{
            let forecast = forecasts[indexPath.row]
            cell.configureUIWithForecastData(forecast: forecast)
        }else {
            let forecast = forecastModels[indexPath.row]
            cell.configureCellWithForecastModel(forecast: forecast)
            
        }
        
        if allForecasts.count != 0 {
            let fullForecast = allForecasts[indexPath.row]
            cell.configureUIWithHourlyData(forecasts: fullForecast)
        }else {
            let fullForecastModel = allHourlyModels[indexPath.row]
            cell.configureCellWithOfflineHourlyData(forecasts: fullForecastModel)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
}

// MARK: - CLLocationManager Delegate

extension MainVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
        
        Location.sharedInstance.latitude = location.coordinate.latitude
        Location.sharedInstance.longitude = location.coordinate.longitude
        
        getFiveDaysForecastData(url: FORECAST_URL)
        getCurrnetWeatherData(url: CURRENT_WHEATER_URL)
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting user location")
    }
    
}
