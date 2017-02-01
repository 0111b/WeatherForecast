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


protocol CaseCountable {
    static var casesCount: Int { get }
    static var allCases: [Self] { get }
}

/** 
 Enum counting
 */
extension CaseCountable where Self: RawRepresentable, Self.RawValue == Int {
    static var casesCount: Int {
        var count = 0
        while Self(rawValue: count) != nil { count += 1 }
        return count
    }
    
    static var allCases: [Self] {
        var all = [Self]()
        var index = 0
        while let theCase = Self(rawValue: index) {
            all.append(theCase)
            index += 1
        }
        return all
    }
}


/**
 Random elemnt
 */
extension Array {
    var randomElement: Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
