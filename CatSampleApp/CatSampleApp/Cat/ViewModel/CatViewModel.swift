//
//  CatViewModel.swift
//  CatSampleApp
//
//  Created by Nabnit Patnaik on 12/22/22.
//

import Foundation
import UIKit
protocol ResponseHandlerDelegate: AnyObject {
    func updateUI()
}

class CatViewModel {
    var description: CatDescriptionModel?
    var image: UIImage?

    var serviceManager: CatServiceManagerDelegate
    
    weak var delegate: ResponseHandlerDelegate?

    init(_ serviceManager: CatServiceManagerDelegate = CatNetworkManager()) {
        self.serviceManager = serviceManager
    }
    
    /// Fetches Cat description and image
    func fetchCatDetails(_ completion: (() -> Void)? = nil) {
        let group = DispatchGroup()
        group.enter()
        serviceManager.getCatDescription { [weak self] (score, error) in
            if let score = score {
                self?.description = score
            }
            group.leave()
        }
        
        group.enter()
        serviceManager.getCatImage { [weak self] (result, error) in
            if let imgData = result {
                self?.image = UIImage(data: imgData)
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            // Update UI after all the details are fetched
            self.delegate?.updateUI()
            
            // Below code is executed only for test cases
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                // Code only executes when tests are running
                if let completion = completion {
                    completion()
                }
            }
        })
    }
}
