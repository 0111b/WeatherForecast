//
//  FeedViewController.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController {
    
    init(coordinator: WeatherFeedCoordinator, city: String, limit: Int) {
        navigationCoordinator = coordinator
        request = API.DailyForecast(city: city, limit: limit)        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) is not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = request.city
        navigationCoordinator.fetcher.fetch(request: request) { result in
            print(result)
        }
    }
    
    @IBOutlet private(set) weak var tableView: UITableView?
    private let request: API.DailyForecast
    fileprivate unowned let navigationCoordinator: WeatherFeedCoordinator
}


// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("\(#function) is not implemented")
    }
    
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationCoordinator.showDayDetails()
    }
}
