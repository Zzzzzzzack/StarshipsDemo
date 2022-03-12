//
//  ZKStarshipViewModelTests.swift
//  StarshipsDemoTests
//
//  Created by Zack on 12/3/22.
//

import XCTest

class ZKStarshipViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUpdateViewModel() throws {
        guard let starship1 = try? ZKJSONUtil.shared.loadDataFromJSONFile(ZKStarship.self, fileName: "Starship1") else {
            XCTAssert(true)
            return
        }

        // Test view model properties by starship1
        let viewModel = ZKStarshipViewModel()
        viewModel.update(starship1)
        XCTAssertEqual(viewModel.name, "CR90 corvette")
        XCTAssertEqual(viewModel.model,  "Model: CR90 corvette")
        XCTAssertEqual(viewModel.manufacturer,  "Manufacturer: Corellian Engineering Corporation")
        XCTAssertEqual(viewModel.costInCredits,  "3500000")
        XCTAssertEqual(viewModel.length,  "150")
        XCTAssertEqual(viewModel.maxSpeed,  "950")
        XCTAssertEqual(viewModel.crew,  "30-165")
        XCTAssertEqual(viewModel.passengers,  "600")
        XCTAssertEqual(viewModel.cargoCapacity,  "3000000")
        XCTAssertEqual(viewModel.consumables,  "1 year")
        XCTAssertEqual(viewModel.hyperdriveRating,  "2.0")
        XCTAssertEqual(viewModel.MGLT,  "60")
        XCTAssertEqual(viewModel.starshipClass,  "corvette")
        XCTAssertEqual(viewModel.pilots?.isEmpty, true)
        XCTAssertEqual(viewModel.films?.count,  3)
        XCTAssertEqual(viewModel.created, "2014-12-10T14:20:33.369000Z")
        XCTAssertEqual(viewModel.edited, "2014-12-20T21:23:49.867000Z")
        XCTAssertEqual(viewModel.url, "https://swapi.dev/api/starships/2/")
        
        viewModel.isFavourite = true
        viewModel.toggleFavourite()
        
        viewModel.isFavourite = nil
        viewModel.toggleFavourite()
        
        // Test empty properties by starship2
        guard let starship2 = try? ZKJSONUtil.shared.loadDataFromJSONFile(ZKStarship.self, fileName: "Starship2") else {
            XCTAssert(true)
            return
        }
        viewModel.update(starship2)
        XCTAssertEqual(viewModel.name, "Star Destroyer")
        XCTAssertNil(viewModel.model)
        XCTAssertNil(viewModel.manufacturer)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
