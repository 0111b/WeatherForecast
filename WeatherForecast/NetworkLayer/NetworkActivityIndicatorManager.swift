//
//  FetchResult.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import UIKit

final class NetworkActivityIndicatorManager {
    private enum ActivityIndicatorState {
        case notActive, delayingStart, active, delayingCompletion
    }
    static let shared = NetworkActivityIndicatorManager()

    /// A boolean value indicating whether the manager is enabled. Defaults to `false`.
    var isEnabled: Bool {
        get {
            lock.lock() ; defer { lock.unlock() }
            return enabled
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            enabled = newValue
        }
    }

    /// A boolean value indicating whether the network activity indicator is currently visible.
    private(set) var isNetworkActivityIndicatorVisible: Bool = false {
        didSet {
            guard isNetworkActivityIndicatorVisible != oldValue else { return }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.isNetworkActivityIndicatorVisible
            }
        }
    }


    private var startDelay: TimeInterval = 0.2
    private var completionDelay: TimeInterval = 0.2

    private var activityIndicatorState: ActivityIndicatorState = .notActive {
        didSet {
            switch activityIndicatorState {
            case .notActive:
                isNetworkActivityIndicatorVisible = false
                invalidateStartDelayTimer()
                invalidateCompletionDelayTimer()
            case .delayingStart:
                scheduleStartDelayTimer()
            case .active:
                invalidateCompletionDelayTimer()
                isNetworkActivityIndicatorVisible = true
            case .delayingCompletion:
                scheduleCompletionDelayTimer()
            }
        }
    }

    private var activityCount: Int = 0
    private var enabled: Bool = true

    private var startDelayTimer: Timer?
    private var completionDelayTimer: Timer?

    private let lock = NSLock()

    init() {
    }

    deinit {
        invalidateStartDelayTimer()
        invalidateCompletionDelayTimer()
    }
    
    func incrementActivityCount() {
        lock.lock() ; defer { lock.unlock() }

        activityCount += 1
        updateActivityIndicatorStateForNetworkActivityChange()
    }


    func decrementActivityCount() {
        lock.lock() ; defer { lock.unlock() }

        activityCount -= 1
        updateActivityIndicatorStateForNetworkActivityChange()
    }

    private func updateActivityIndicatorStateForNetworkActivityChange() {
        guard enabled else { return }

        switch activityIndicatorState {
        case .notActive:
            if activityCount > 0 { activityIndicatorState = .delayingStart }
        case .delayingStart:
            // No-op - let the delay timer finish
            break
        case .active:
            if activityCount == 0 { activityIndicatorState = .delayingCompletion }
        case .delayingCompletion:
            if activityCount > 0 { activityIndicatorState = .active }
        }
    }

    private func scheduleStartDelayTimer() {
        let timer = Timer(
            timeInterval: startDelay,
            target: self,
            selector: #selector(NetworkActivityIndicatorManager.startDelayTimerFired),
            userInfo: nil,
            repeats: false
        )

        DispatchQueue.main.async {
            RunLoop.main.add(timer, forMode: .commonModes)
            RunLoop.main.add(timer, forMode: .UITrackingRunLoopMode)
        }

        startDelayTimer = timer
    }

    private func scheduleCompletionDelayTimer() {
        let timer = Timer(
            timeInterval: completionDelay,
            target: self,
            selector: #selector(NetworkActivityIndicatorManager.completionDelayTimerFired),
            userInfo: nil,
            repeats: false
        )

        DispatchQueue.main.async {
            RunLoop.main.add(timer, forMode: .commonModes)
            RunLoop.main.add(timer, forMode: .UITrackingRunLoopMode)
        }

        completionDelayTimer = timer
    }

    @objc private func startDelayTimerFired() {
        lock.lock() ; defer { lock.unlock() }

        if activityCount > 0 {
            activityIndicatorState = .active
        } else {
            activityIndicatorState = .notActive
        }
    }

    @objc private func completionDelayTimerFired() {
        lock.lock() ; defer { lock.unlock() }
        activityIndicatorState = .notActive
    }

    private func invalidateStartDelayTimer() {
        startDelayTimer?.invalidate()
        startDelayTimer = nil
    }

    private func invalidateCompletionDelayTimer() {
        completionDelayTimer?.invalidate()
        completionDelayTimer = nil
    }
}
