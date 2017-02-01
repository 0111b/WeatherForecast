//
//  DataFetchRequest.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import Foundation

protocol DataFetchRequest {
    associatedtype Result
    typealias Parameters = [String: String]
    var url: String { get }
    var parameters: Parameters { get }
    var mapping: Mapping<Result> { get }
}

extension DataFetchRequest {
    var parameters: Parameters { return [:] }
}

protocol DataFetcher {
    
    @discardableResult
    func fetch<Request: DataFetchRequest>(request: Request,
               completion: @escaping (FetchResult<Request.Result>) -> Void
        ) -> Cancelable
}

extension NetworkDataProvider: DataFetcher {
    
    @discardableResult
    func fetch<Request: DataFetchRequest>(request: Request,
               completion: @escaping (FetchResult<Request.Result>) -> Void
        ) -> Cancelable {
        return get(url: request.url, parameters: request.parameters, map: request.mapping, completion: completion)
    }
}
