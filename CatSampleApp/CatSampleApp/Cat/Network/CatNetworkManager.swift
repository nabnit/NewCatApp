//
//  CatNetworkManager.swift
//  CatSampleApp
//
//  Created by Nabnit Patnaik on 12/22/22.
//

import Foundation
import UIKit

protocol CatServiceManagerDelegate {
    func getCatDescription(completionHandler: @escaping (CatDescriptionModel?, NetworkError?)-> Void)
    func getCatImage(completionHandler: @escaping (Data?, NetworkError?)-> Void)
}

struct CatNetworkManager: CatServiceManagerDelegate {
    let networkManager: WebServiceManager
    
    init(_ networkManager: WebServiceManager = WebServiceManager()) {
        self.networkManager = networkManager
    }
    
    /// Fetches Cat description
    func getCatDescription(completionHandler: @escaping (CatDescriptionModel?, NetworkError?)-> Void) {
        let catDescriptionUrl = CatConstants.catDescription.rawValue
        guard let catUrl = URL(string: catDescriptionUrl) else {
            completionHandler(nil, .InvalidUrl)
            return
        }
        networkManager.makeAPIRequest(catUrl, CatDescriptionModel.self) { parsedResponse, error in
            if let _ = error {
                completionHandler(nil, .NilResponse)
            }
            else {
                completionHandler(parsedResponse, nil)
            }
        }
    }
    
    /// Fetches Cat Image data
    func getCatImage(completionHandler: @escaping (Data?, NetworkError?)-> Void) {
        // To generate random width and height, for getting random photos
        let randomWidth = Int.random(in: 400..<900)
        let randomHeight = Int.random(in: 400..<900)
        
        let scoreBaseUrl = CatConstants.catImageUrl.rawValue + "\(randomWidth)/\(randomHeight)"
        guard let scoreUrl = URL(string: scoreBaseUrl) else {
            completionHandler(nil, .InvalidUrl)
            return
        }
        networkManager.makeAPIRequestToDownloadImage(scoreUrl) { parsedResponse, error in
            if let _ = error {
                completionHandler(nil, .NilResponse)
            }
            else {
                completionHandler(parsedResponse, nil)
            }
        }
    }


}
