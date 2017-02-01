//
//  NetworkDataProvider.swift
//  WeatherForecast
//
//  Created by Alexandr Goncharov on 01/02/2017.
//  Copyright © 2017 Alexandr Goncharov. All rights reserved.
//

import Foundation

final class NetworkDataProvider {
    
    enum NetworkError: Error {
        /// general unhandled error
        case unknown(underlying: Error)
        ///request was canceled
        case canceled
        /// error while creating request
        case invalidRequest
        /// bad response
        case badResponse(details: Any)
    }

    @discardableResult
    func get<Response>(url urlString: String,
                     parameters: [String: String] = [:],
                     map mapping: @escaping Mapping<Response>,
                     completion: @escaping (FetchResult<Response>) -> Void
                     ) -> Cancelable {
        
        func makeRequest(urlString: String, params: [String: String]) -> URLRequest? {
            guard var components = URLComponents(string: urlString) else { return nil }
            var query = parameters.map { URLQueryItem(name: $0, value: $1) }
            query += components.queryItems ?? []
            query.append(URLQueryItem(name: "APPID", value: apiKey))
            components.queryItems = query
            return components.url.map{ URLRequest(url: $0) }
        }
        
        guard let req = makeRequest(urlString: urlString, params: parameters) else {
            completion(.failure(NetworkError.invalidRequest))
            return StubCancelable()
        }
        
        return request(req, map: mapping, completion: completion)
    }

    @discardableResult
    func request<Response>(_ request: URLRequest,
                     map mapping: @escaping Mapping<Response>,
                     completion: @escaping (FetchResult<Response>) -> Void
                     ) -> Cancelable {
        //TODO: Increment activity count
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            let result = NetworkDataProvider.serialize(mapping: mapping, data: data, response: response, error: error)
            completion(result)
        })
        task.resume()
        return task
    }
    
    
    init(apiKey: String, configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.apiKey = apiKey
        session = URLSession(configuration: configuration)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    private let session: URLSession
    private let apiKey: String
    
    private static func serialize<Response>(mapping: @escaping Mapping<Response>, data: Data?, response: URLResponse?, error: Error?) -> FetchResult<Response> {
        //TODO: improve error handling
        guard error == nil else { return .failure(NetworkError.unknown(underlying: error!)) }
        let badResponseResult:FetchResult<Response> = .failure(NetworkError.badResponse(details: response as Any))
        guard let validData = data else { return  badResponseResult}
        do {
            let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
            guard let object = try mapping(json) else { return badResponseResult }
            return .success(object)
        } catch {
            return badResponseResult
        }
    }
}

extension URLSessionDataTask: Cancelable {}
