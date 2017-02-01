//
//  ForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var weatherImageView: UIImageView?
    @IBOutlet private weak var captionLabel: UILabel?
    
    static let cellId = String(describing: ForecastTableViewCell.self)
    
    func configure(with forecast: Forecast) {
        let dayNumber = NSCalendar.current.component(.weekday, from: forecast.date)
        let dayName = DateFormatter().weekdaySymbols[dayNumber - 1]
        captionLabel?.text = dayName
        weatherImageView?.image = WeatherImage.allCases.randomElement.image
    }
    
    enum WeatherImage: Int, CaseCountable {
        case cloudy
        case sunny
        case rainy
        
        var image: UIImage {
            switch self {
            case .cloudy: return #imageLiteral(resourceName: "Cloudy")
            case .sunny: return #imageLiteral(resourceName: "Sunny")
            case .rainy: return #imageLiteral(resourceName: "Rainy")
            }
        }
        
    }
}
