//
//  API.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import Foundation

enum API {
    struct DailyForecast: DataFetchRequest {
        
        let city: String
        let limit: Int
        
        typealias Result = [Forecast]
        var url: String { return "http://api.openweathermap.org/data/2.5/forecast/daily" }
        var parameters: DataFetchRequest.Parameters {
            return [
                "q" : city,
                "cnt" : "\(limit)",
                "units" : "metric",
            ]
        }
        var mapping: Mapping<Result> {
            return { json in
                return nil
            }
        }

    }
}
