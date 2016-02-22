//
//  Network.swift
//  WeatherFeather
//
//  Created by Joshua O'Connor on 8/22/15.
//  Copyright (c) 2015 Joshua O'Connor. All rights reserved.
//

import Foundation

//Our Network class.  Handles retrieving our API data in JSON.
class Network {
    
    //Our declared variables
    //Lazy won't use memory.  Will be called only when absolutely necessary
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    //Init Method
    init(url: NSURL) {
        self.queryURL = url
    }
    
    //Typealias for more readable code
    typealias JSONDictionaryCompletion = ([String: AnyObject]? -> Void)
    
    //Download JSON Data function with JSONDictionaryCompletion completion
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        
        //Our constants
        let request = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            //Check HTTP  for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    //Create JSON object
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
                    completion(jsonDictionary)
                default:
                    println("GET request failed")
                }
            } else {
                println("Error")
            }
        }
        //Resume dataTask
        dataTask.resume()
    }
}
