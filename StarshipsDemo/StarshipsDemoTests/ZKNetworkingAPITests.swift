//
//  ZKNetworkingAPITests.swift
//  StarshipsDemoTests
//
//  Created by Zack on 11/3/22.
//

import XCTest

class ZKNetworkingAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStarshipsAPIEnums() throws {
        let starshipsListAPI = ZKNetworkAPI.starships(.list)
        XCTAssertEqual(starshipsListAPI.urlString, "https://swapi.dev/api/starships/")
        XCTAssertEqual(starshipsListAPI.method, .get)
        
        let starshipDetailsAPI =  ZKNetworkAPI.starships(.details("2"))
        XCTAssertEqual(starshipDetailsAPI.urlString, "https://swapi.dev/api/starships/2")
        XCTAssertEqual(starshipDetailsAPI.method, .get)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
