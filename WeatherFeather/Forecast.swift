//
//  Forecast.swift
//  WeatherFeather
//
//  Created by Joshua O'Connor on 8/22/15.
//  Copyright (c) 2015 Joshua O'Connor. All rights reserved.
//

import Foundation

//Our Forecast Struct
struct Forecast {
    
    //Our constants
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    //Init method
    init(APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    //Get forecast function
    func getForecast(lat: Double, lon: Double, completion: (Weather? -> Void)) {
        
        if let forecastURL = NSURL(string: "\(lat),\(lon)", relativeToURL: forecastBaseURL) {
            let networkOperation = Network(url: forecastURL)
            
            //Get JSON Data
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let currentWeather = self.currentWeatherFromJSONDictionary(JSONDictionary)
                completion(currentWeather)
            }
        } else {
            println("Not a valid URL")
        }
    }
    
    func currentWeatherFromJSONDictionary(jsonDictionary: [String: AnyObject]?) -> Weather? {
        if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String: AnyObject] {
            return Weather(weatherDictionary: currentWeatherDictionary)
        } else {
            println("JSON = nil")
            return nil
        }
    }
    
}