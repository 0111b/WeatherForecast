//
//  NavigationRouter.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import Foundation


protocol NavigationCooridator {
    func start()
    func addChild(coordinator: NavigationCooridator)
    func removeChild(coordinator: NavigationCooridator)
}

