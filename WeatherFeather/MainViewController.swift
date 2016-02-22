//
//  ViewController.swift
//  WeatherFeather
//
//  Created by Joshua O'Connor on 8/22/15.
//  Copyright (c) 2015 Joshua O'Connor. All rights reserved.
//

import UIKit
import CoreLocation

//Our Main Class
class MainViewController: UIViewController, CLLocationManagerDelegate {

    //Our Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentRainLabel: UILabel?
    @IBOutlet weak var currentWindSpeedLabel: UILabel!
    @IBOutlet weak var currentCloudCoverLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    
    
    //https://developer.forecast.io/ <--API source
    private let weatherAPIkey = "9301f53588e5404881534e7a842abcd6"

    //Our variables
    var latitude: Double = Double()
    var longitude: Double = Double()
    var city: String = String()
    var country: String = String()
    let locationManager = CLLocationManager()
    
    //viewDidLoad, run locationManager
    override func viewDidLoad() {
        super.viewDidLoad()
        precipLabel.hidden = true
        humidityLabel.hidden = true
        windSpeedLabel.hidden = true
        cloudCoverLabel.hidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Get Forecast function, gets data from API using Forecast.swift class
    func getForecast() {
        
        //Call Forecast class, use API in weatherAPI variable
        let forecastService = Forecast(APIKey: weatherAPIkey)
        
        //Call forecast for lat and long obtained from locationManager
        forecastService.getForecast(latitude, lon: longitude) {
            (let currently) in
            
            if let currentWeather = currently {
                
                //Lets execute on the main queue!
                dispatch_async(dispatch_get_main_queue()) {
                    
                    //Set temperature
                    if let temperature = currentWeather.temperature {
                        self.currentTempLabel?.text = "\(temperature)º"
                    }
                    
                    //Set humidity
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    
                    //Set chance of rain
                    if let precipProbability = currentWeather.precipProbability {
                        self.currentRainLabel?.text = "\(precipProbability)%"
                    }
                    
                    //Set windSpeed
                    if let windSpeed = currentWeather.windSpeed {
                        self.currentWindSpeedLabel?.text = "\(windSpeed) MPH"
                    }
                    
                    //Set cloudCover
                    if let cloudCover = currentWeather.cloudCover {
                        self.currentCloudCoverLabel?.text = "\(cloudCover)%"
                    }
                    
                    
                    //Set icon
                    if let icon = currentWeather.icon {
                        self.weatherIcon?.image = icon
                    }
                    
                    //Set city and county
                    self.cityLabel.text = self.city
                    self.countryLabel.text = self.country
                    self.precipLabel.hidden = false
                    self.humidityLabel.hidden = false
                    self.windSpeedLabel.hidden = false
                    self.cloudCoverLabel.hidden = false
                    //Stop animating
                    self.refreshAnimation(false)
                    
                }
            }
        }
    }
        
    //Refresh data function, when user clicks refresh button.
    @IBAction func refreshData(sender: AnyObject) {
        refreshAnimation(true)
        getForecast()
        
    }
    
    //Refresh animation function.
    func refreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndicator?.startAnimating()
        }
        else {
            activityIndicator?.stopAnimating()
        }
    }
    
    //Location Manager
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            //Error!
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            //No error
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
                
            }
            //Problem with geocoder
            else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    //Display Location Info
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            //Stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            //City and Country Values
            let localityData = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let countryData = (containsPlacemark.country != nil) ? containsPlacemark.country : ""

            //Set values to stored variables
            city = localityData
            country = countryData
            latitude = Double(containsPlacemark.location.coordinate.latitude)
            longitude = Double(containsPlacemark.location.coordinate.longitude)
            
            //Run Get Forecast method (call API with new lat and long values)
            getForecast()
            
        }
        
    }
    
    //Location Manager failed
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    

}

