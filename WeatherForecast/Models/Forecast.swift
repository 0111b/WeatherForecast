//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import Foundation

struct Forecast {
    let date: Date
    let weatherDescription: String
    let humidity: String
    let tempMax: Double
    let tempMin: Double
}


extension Forecast {
    //TODO: use some mapping library
    init?(dictionary: [String: Any]) {
        guard let time = dictionary["dt"] as? TimeInterval,
            let humidity = dictionary["humidity"] as? NSNumber,
            let temperature = dictionary["temp"] as? [String: Any],
            let tempMin = temperature["min"] as? Double,
            let tempMax = temperature["max"] as? Double,
            let weather = dictionary["weather"] as? [[String: Any]],
            let weatherDescription = weather.first?["description"] as? String
            else {
                return nil
        }
        date = Date(timeIntervalSinceReferenceDate: time)
        self.weatherDescription = weatherDescription
        self.humidity = humidity.stringValue
        self.tempMax = tempMax
        self.tempMin = tempMin
    }
}
