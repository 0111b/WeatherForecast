//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

struct Forecast {
    let date: Date
    let weatherDescription: String
    let humidity: String
    let tempMax: Double
    let tempMin: Double
    let image: WeatherImage
    
    enum WeatherImage: Int, CaseCountable {
        case cloudy
        case sunny
        case rainy
        
        var uiImage: UIImage {
            switch self {
            case .cloudy: return #imageLiteral(resourceName: "Cloudy")
            case .sunny: return #imageLiteral(resourceName: "Sunny")
            case .rainy: return #imageLiteral(resourceName: "Rainy")
            }
        }
        
    }
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
        image = WeatherImage.allCases.randomElement
    }
}

extension Forecast {
    var dayName: String {
        let dayNumber = NSCalendar.current.component(.weekday, from: date)
        return DateFormatter().weekdaySymbols[dayNumber - 1]
    }
}
