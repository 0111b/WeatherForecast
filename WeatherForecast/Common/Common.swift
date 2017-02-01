//
//  Cancelable.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import Foundation



typealias Mapping<T> = (Any) throws -> T?

protocol Cancelable {
    func cancel()
}

/**
 Stub, return whenever need to stub actual Cancelable
 */
final class StubCancelable: Cancelable {
    func cancel() {}
}
