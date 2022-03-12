//
//  ZKStarshipDetailViewModelTests.swift
//  StarshipsDemoTests
//
//  Created by Zack on 12/3/22.
//

import XCTest

class ZKStarshipDetailViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateStarshipDetail() throws {
        // Load the mock date from JSON file
        guard let starship = try? ZKJSONUtil.shared.loadDataFromJSONFile(ZKStarship.self, fileName: "Starship1") else {
            XCTAssert(true)
            return
        }
        
        let viewModel = ZKStarshipDetailViewModel()
        
        for detailType in ZKStarshipViewModel.DetailType.allCases {
            viewModel.update(starship, detailType: detailType)

            // Validate title test
            XCTAssertEqual(viewModel.title, detailType.rawValue + ":")
            
            // Validate detail content
            switch detailType {
            case .model:
                XCTAssertEqual(viewModel.detail, starship.model)
            case .manufacturer:
                XCTAssertEqual(viewModel.detail, starship.manufacturer)
            case .costInCredits:
                XCTAssertEqual(viewModel.detail, starship.costInCredits)
            case .length:
                XCTAssertEqual(viewModel.detail, starship.length)
            case .maxSpeed:
                XCTAssertEqual(viewModel.detail, starship.maxSpeed)
            case .crew:
                XCTAssertEqual(viewModel.detail, starship.crew)
            case .passengers:
                XCTAssertEqual(viewModel.detail, starship.passengers)
            case .cargoCapacity:
                XCTAssertEqual(viewModel.detail, starship.cargoCapacity)
            case .consumables:
                XCTAssertEqual(viewModel.detail, starship.consumables)
            case .hyperdriveRating:
                XCTAssertEqual(viewModel.detail, starship.hyperdriveRating)
            case .MGLT:
                XCTAssertEqual(viewModel.detail, starship.MGLT)
            case .starshipClass:
                XCTAssertEqual(viewModel.detail, starship.starshipClass)
            case .pilots:
                XCTAssertEqual(viewModel.detail, starship.pilots?.joined(separator: "\n"))
            case .films:
                XCTAssertEqual(viewModel.detail, starship.films?.joined(separator: "\n"))
            case .created:
                XCTAssertEqual(viewModel.detail, starship.created)
            case .edited:
                XCTAssertEqual(viewModel.detail, starship.edited)
            }
        }
        
        // Validate empty detail content
        viewModel.update(nil, detailType: ZKStarshipViewModel.DetailType.model)
        XCTAssertNil(viewModel.detail)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
