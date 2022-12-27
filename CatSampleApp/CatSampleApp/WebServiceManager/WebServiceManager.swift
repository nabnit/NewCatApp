//
//  WebServiceManager.swift
//  CatSampleApp
//
//  Created by Nabnit Patnaik on 12/22/22.
//

import Foundation
import UIKit
/// Custom Error enum to handle additional error scenarios
enum NetworkError: Error {
    case ResponseParsingFailed
    case NilResponse
    case InvalidUrl
}
protocol NetworkProvider {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    func performRequest(url: URL, completion: @escaping Handler)
}

struct WebServiceManager {
    
    private let networkEngine: NetworkProvider
    
    init(_ engine: NetworkProvider = URLSession.shared) {
        self.networkEngine = engine
    }
    
    /// Generic function to make API Request
    /// - Parameters:
    ///   - url: Request url
    ///   - model: Type of Model expected to be in the response and parsed
    ///   - completion: Returns the parsed reponse model and error(if any)
    func makeAPIRequest<T: Decodable>(_ url: URL,_ model: T.Type, completion: @escaping (T?, NetworkError?)-> Void) {
        networkEngine.performRequest(url: url) { data, response, error in
            guard let data = data else {
                completion(nil, .NilResponse)
                return
            }
            do {
                let result: T = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            }
            catch {
                completion(nil, .ResponseParsingFailed)
            }
        }
    }
    
    /// Function to fetch Data from a URL
    /// - Parameters:
    ///   - url: Request url
    ///   - completion: Returns the data and error(if any)
    func makeAPIRequestToDownloadImage(_ url: URL, completion: @escaping (Data?, NetworkError?) -> Void) {
        networkEngine.performRequest(url: url) { data, response, error in
            guard let data = data else {
                completion(nil, .NilResponse)
                return
            }
            completion(data, nil)
        }

    }
}

extension URLSession: NetworkProvider {
    typealias Handler = NetworkProvider.Handler
    func performRequest(url: URL, completion: @escaping Handler) {
        self.configuration.timeoutIntervalForRequest = 3.0
        let task = dataTask(with: url, completionHandler: completion)
        task.resume()
    }
    
}
