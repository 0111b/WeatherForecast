//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var initialCoordinator: NavigationCooridator?
    private lazy var fetcher: DataFetcher = {
        let apiKey = "0ca3d5502dce494c8bd95fa7123afe75"
        return NetworkDataProvider(apiKey: apiKey)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.makeKeyAndVisible()
        window = rootWindow
        initialCoordinator = WeatherFeedCoordinator(window: rootWindow, dataFetcher: fetcher)
        initialCoordinator?.start()
        return true
    }    
}

