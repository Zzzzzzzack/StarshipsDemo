//
//  ZKStarshipsViewModelTests.swift
//  StarshipsDemoTests
//
//  Created by Zack on 12/3/22.
//

import XCTest
import Combine

class ZKStarshipsViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetStarships() throws {
        let expectation = self.expectation(description: "Test Get Starships")
        let networking = ZKNetworkingTests()
        networking.responseFileName = "GetStarshipsResponse"
        let viewModel = ZKStarshipsViewModel(networking)
        viewModel.getStarships()
        viewModel.$starships.sink(receiveValue: {
            // Check the response data
            XCTAssertEqual($0?.count, 10)
            let firstStarship = $0?.first
            XCTAssertEqual(firstStarship?.name, "CR90 corvette")
            XCTAssertEqual(firstStarship?.model,  "CR90 corvette")
            XCTAssertEqual(firstStarship?.manufacturer,  "Corellian Engineering Corporation")
            XCTAssertEqual(firstStarship?.costInCredits,  "3500000")
            XCTAssertEqual(firstStarship?.length,  "150")
            XCTAssertEqual(firstStarship?.maxSpeed,  "950")
            XCTAssertEqual(firstStarship?.crew,  "30-165")
            XCTAssertEqual(firstStarship?.passengers,  "600")
            XCTAssertEqual(firstStarship?.cargoCapacity,  "3000000")
            XCTAssertEqual(firstStarship?.consumables,  "1 year")
            XCTAssertEqual(firstStarship?.consumables,  "1 year")
            XCTAssertEqual(firstStarship?.hyperdriveRating,  "2.0")
            XCTAssertEqual(firstStarship?.MGLT,  "60")
            XCTAssertEqual(firstStarship?.starshipClass,  "corvette")
            XCTAssertEqual(firstStarship?.pilots?.isEmpty, true)
            XCTAssertEqual(firstStarship?.films?.count,  3)
            XCTAssertEqual(firstStarship?.created, "2014-12-10T14:20:33.369000Z")
            XCTAssertEqual(firstStarship?.edited, "2014-12-20T21:23:49.867000Z")
            XCTAssertEqual(firstStarship?.url, "https://swapi.dev/api/starships/2/")
            expectation.fulfill()
        }).store(in: &self.subscriptions)
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
