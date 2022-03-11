//
//  ZKErrorTests.swift
//  StarshipsDemoTests
//
//  Created by Zack on 11/3/22.
//

import XCTest

class ZKErrorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkingErrorDescriptions() throws {
        let invalidURLError = ZKNetworkingError.invalidURL
        XCTAssertEqual(invalidURLError.errorDescription, "Invalid URL")

        let serverError = ZKNetworkingError.serverError
        XCTAssertEqual(serverError.errorDescription, "Server Error")

        let customMessage = "Custom Message Error"
        let customError = ZKNetworkingError.custom(message: customMessage)
        XCTAssertEqual(customError.errorDescription, customMessage)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
