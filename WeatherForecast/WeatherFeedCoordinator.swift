//
//  WeatherFeedCoordinator.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

final class WeatherFeedCoordinator: NavigationCooridator {
    init(window: UIWindow, dataFetcher: DataFetcher) {
        rootWindow = window
        fetcher = dataFetcher
    }
    
    let fetcher: DataFetcher
    private unowned let rootWindow: UIWindow
    
    func showDayDetails() {
        
    }
    
    func start() {
        let city = "London"
        let days = 7
        let feedController = FeedViewController(coordinator: self, city: city, limit: days)
        let navigationController = UINavigationController(rootViewController: feedController)
        rootWindow.rootViewController = navigationController        
    }
    
    
    func addChild(coordinator: NavigationCooridator) {
        //TODO: implement
    }
    
    func removeChild(coordinator: NavigationCooridator) {
        //TODO: implement
    }
            
}
