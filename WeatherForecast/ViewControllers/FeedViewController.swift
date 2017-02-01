//
//  FeedViewController.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController {
    
    //TODO: implement generic cell loading
    
    init(coordinator: WeatherFeedCoordinator, city: String, limit: Int) {
        navigationCoordinator = coordinator
        request = API.DailyForecast(city: city, limit: limit)        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) is not implemented")
    }
    
    private enum State {
        case error
        case loading
        case none
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = request.city
        
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        let refreshTitle = NSLocalizedString("Updating forecast", comment: "Feed pull to refresh caption")
        refreshControl.attributedTitle = NSAttributedString(string: refreshTitle)
        refreshControl.addTarget(self, action: .askForRefresh, for: .valueChanged)
        tableView?.addSubview(refreshControl)
        
        tableView?.register(UINib(nibName: ForecastTableViewCell.cellId, bundle: Bundle.main), forCellReuseIdentifier: ForecastTableViewCell.cellId)
        
        state = .loading
    }
    
    @IBAction func didTriggerRefresh() {
        state = .loading
    }
    
    private func reloadData() {
        refreshControl?.beginRefreshing()
        navigationCoordinator.fetcher.fetch(request: request) { [weak self] result in
            guard let this = self else { return }
            defer { this.refreshControl?.endRefreshing() }
            switch result {
            case .success(let items):
                this.items = items
                this.tableView?.reloadData()
                this.state = .none
            case .failure(let error):
                print(error)
                this.state = .error
            }
            
        }
    }
    
    private func update(for state: State) {
        errorView?.isHidden = true
        switch state {
        case .loading:
            reloadData()
        case .error:
            errorView?.isHidden = false
        case .none:
            break
        }
    }
    
    fileprivate func itemFor(indexPath: IndexPath) -> Forecast? {
        guard indexPath.row < items.count else { return nil }
        return items[indexPath.row]
    }
    
    @IBOutlet private weak var errorView: UILabel?
    @IBOutlet private(set) weak var tableView: UITableView?
    private let request: API.DailyForecast
    fileprivate unowned let navigationCoordinator: WeatherFeedCoordinator
    private var refreshControl: UIRefreshControl?
    private var state: State = .none {
        didSet {
            update(for: state)
        }
    }
    fileprivate var items = [Forecast]()
}

private extension Selector {
    static let askForRefresh = #selector(FeedViewController.didTriggerRefresh)
}


// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.cellId, for: indexPath) as? ForecastTableViewCell,
            let item = itemFor(indexPath: indexPath)
            else {
            fatalError("Could not load ForecastTableViewCell: \(indexPath)")
        }
        cell.configure(with: item)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let forecast = itemFor(indexPath: indexPath) else { return }
        navigationCoordinator.showForecastDetails(forecast)
    }
}
