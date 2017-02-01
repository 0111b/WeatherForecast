//
//  WeatherFeedCoordinator.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

final class WeatherFeedCoordinator: NavigationCooridator {
    init(window: UIWindow) {
        rootWindow = window
    }
    
    func showDayDetails() {
        
    }
    
    func start() {
        let feedController = FeedViewController(coordinator: self)
        let navigationController = UINavigationController(rootViewController: feedController)
        rootWindow.rootViewController = navigationController        
    }
    
    
    func addChild(coordinator: NavigationCooridator) {
        //TODO: implement
    }
    
    func removeChild(coordinator: NavigationCooridator) {
        //TODO: implement
    }
    
    private unowned let rootWindow: UIWindow
    
}
