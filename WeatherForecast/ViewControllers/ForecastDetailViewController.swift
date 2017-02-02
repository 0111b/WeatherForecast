//
//  ForecastDetailViewController.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

final class ForecastDetailViewController: UIViewController {
    init(coordinator: WeatherFeedCoordinator, forecast: Forecast) {
        navigationCoordinator = coordinator
        self.forecast = forecast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) is not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backTitle = NSLocalizedString("Back", comment: "ForecastDetailViewController back title")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: backTitle, style: .plain, target: self, action: .back)
        title = forecast.dayName
        weatherImageView?.image = forecast.image.uiImage
        descriptionLabel?.text = forecast.weatherDescription
        maxLabel?.text = String.localizedStringWithFormat(NSLocalizedString("Hight: %.1f °C", comment: "ForecastDetailViewController tempMax"), forecast.tempMax)
        minLabel?.text = String.localizedStringWithFormat(NSLocalizedString("Low: %.1f °C", comment: "ForecastDetailViewController tempMin"), forecast.tempMin)
        humidityLabel?.text = String.localizedStringWithFormat(NSLocalizedString("Humidity: %@%%", comment: "ForecastDetailViewController humidity"), forecast.humidity)
    }

    @IBAction func goBack(sender: Any) {
        navigationCoordinator.returnFromProductDetails()
    }
    
    fileprivate unowned let navigationCoordinator: WeatherFeedCoordinator
    private let forecast: Forecast
    
    @IBOutlet private weak var weatherImageView: UIImageView?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var humidityLabel: UILabel?
    @IBOutlet private weak var maxLabel: UILabel?
    @IBOutlet private weak var minLabel: UILabel?
}

private extension Selector {
    static let back = #selector(ForecastDetailViewController.goBack(sender:))
}
