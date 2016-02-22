//
//  Weather.swift
//  WeatherFeather
//
//  Created by Joshua O'Connor on 8/22/15.
//  Copyright (c) 2015 Joshua O'Connor. All rights reserved.
//

import Foundation
import UIKit

//Our Icon Enum, for our weather icon images
enum Icon: String {
    
    //Our cases
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Cloudy = "cloudy"
    case Fog = "fog"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"

    //Our to Image function, returns an UIImage
    func toImage() -> UIImage? {
        
        //imageName variable
        var imageName: String
        
        //Switch statement for our cases.
        switch self {
            case .ClearDay:
                imageName = "clear-day.png"
            case .ClearNight:
                imageName = "clear-night.png"
            case .Cloudy:
                imageName = "cloudy.png"
            case .Fog:
                imageName = "fog.png"
            case .PartlyCloudyDay:
                imageName = "cloudy-day.png"
            case .PartlyCloudyNight:
                imageName = "cloudy-night.png"
            case .Rain:
                imageName = "rain.png"
            case .Snow:
                imageName = "snow.png"
            case .Sleet:
                imageName = "sleet.png"
            case .Wind:
                imageName = "wind.png"
        }
        
        return UIImage(named: imageName)
    }
}

//Our Weather struct
struct Weather {
    
    //Declared constants and variables
    let temperature: Int?
    let humidity: Int?
    let precipProbability: Int?
    
    let cloudCover: Int?
    let windSpeed: Int?
    
    
    let summary: String?
    var icon: UIImage? = UIImage(named: "default.png")
    
    //Our init method
    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temperature"] as? Int
        
        //Get humidity value from JSON feed
        if let humidityFloat = weatherDictionary["humidity"] as? Double {
            humidity = Int(humidityFloat * 100)
        } else {
            humidity = nil
        }
        
        //Get precipProbability value from JSON feed
        if let precipFloat = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipFloat * 100)
        } else {
            precipProbability = nil
        }
        
        //Get cloudCover value from JSON feed
        if let cloudCoverFloat = weatherDictionary["cloudCover"] as? Double {
            cloudCover = Int(cloudCoverFloat * 100)
        } else {
            cloudCover = nil
        }
        
        //Get windSpeed value from JSON feed
        if let windSpeedFloat = weatherDictionary["windSpeed"] as? Double {
            windSpeed = Int(windSpeedFloat)
        } else {
            windSpeed = nil
        }
        
        
        //Get summary value from JSON feed for our icons
        summary = weatherDictionary["summary"] as? String
        if let iconString = weatherDictionary["icon"] as? String,
            let weatherIcon: Icon = Icon(rawValue: iconString) {
                icon = weatherIcon.toImage()
        }
    }
}
