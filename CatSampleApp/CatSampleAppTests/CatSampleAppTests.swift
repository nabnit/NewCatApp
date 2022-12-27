//
//  CatSampleAppTests.swift
//  CatSampleAppTests
//
//  Created by Nabnit Patnaik on 12/22/22.
//

import XCTest
@testable import CatSampleApp

class CatSampleAppTests: XCTestCase {

    let catViewModel = CatViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testCatDetailsSuccess() throws {
        let mockViewController = MockCatViewController()
        catViewModel.delegate = mockViewController
        // Using the MockNetworkProvider to provide a dummy response
        let serviceManager = CatNetworkManager(WebServiceManager(MockNetworkProvider()))
        catViewModel.serviceManager = serviceManager
        let exp = expectation(description: "Details success")
        catViewModel.fetchCatDetails {
            XCTAssertEqual(self.catViewModel.description?.data, ["All cats have three sets of long hairs that are sensitive to pressure - whiskers, eyebrows,and the hairs between their paw pads."])
            XCTAssertEqual(mockViewController.isUpdateUICalled, true)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)


    }
    func testCatDetailsFailure() throws {
        let mockViewController = MockCatViewController()
        catViewModel.delegate = mockViewController
        // Using the MockNetworkProvider to provide a dummy response
        var mockNetworkProvider = MockNetworkProvider()
        mockNetworkProvider.failureResponse = true
        let serviceManager = CatNetworkManager(WebServiceManager(mockNetworkProvider))
        catViewModel.serviceManager = serviceManager
        mockViewController.catViewModel = catViewModel
        let exp = expectation(description: "Details failure")
        catViewModel.fetchCatDetails {
            XCTAssertEqual(self.catViewModel.description?.data, nil)
            XCTAssertEqual(mockViewController.isUpdateUICalled, true)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
}

struct MockNetworkProvider: NetworkProvider {
    typealias Handler = NetworkProvider.Handler
    
    var failureResponse = false
    
    func performRequest(url: URL, completion: @escaping Handler) {
        let mockResponse = failureResponse ? nil : " { \"data\": [\"All cats have three sets of long hairs that are sensitive to pressure - whiskers, eyebrows,and the hairs between their paw pads.\"] } "
        
        completion(mockResponse?.data(using: .utf8), HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
    }
}

class MockCatViewController: ResponseHandlerDelegate {
    var isUpdateUICalled = false
    var catViewModel: CatViewModel?
    func updateUI() {
        isUpdateUICalled = true
    }
    
}
