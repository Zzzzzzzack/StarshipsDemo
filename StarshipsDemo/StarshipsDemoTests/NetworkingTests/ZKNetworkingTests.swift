//
//  ZKNetworkingTests.swift
//  StarshipsDemoTests
//
//  Created by Zack on 11/3/22.
//

import XCTest

class ZKNetworkingTests: XCTestCase, ZKNetworkingProtocol {

    // File name of the mack response
    var responseFileName: String = ""
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // This get starships list success from server
    // This test is rely on internet
    func testGetStarshipsListSuccessFromServer() {
        let request = ZKGetStarshipsRequest(params: ZKGetStarshipsRequestParams(page: 1))
        self.testSendRequest("Test Get Starships List Success From Server") { expectation in
            // Get starships list from server
            ZKNetworking.shared.send(request: request) { response, error in
                XCTAssertNil(error)
                XCTAssertEqual(response?.data?.next, "https://swapi.dev/api/starships/?page=2")
                XCTAssertEqual(response?.data?.starships?.isEmpty, false)
                XCTAssertTrue(response?.data?.starships?.first?.name != nil)
                expectation.fulfill()
            }
        }
    }
    
    // This get starships list failed from server
    // This test is rely on internet
    func testGetStarshipsListFailedFromServer() {
        // Use the ver big page to failed the request
        let request = ZKGetStarshipsRequest(params: ZKGetStarshipsRequestParams(page: 9999999))
        self.testSendRequest("Test Get Starships List Failed From Server") { expectation in
            // Get starships list from server
            ZKNetworking.shared.send(request: request) { response, error in
                XCTAssertNotNil(error)
                XCTAssertEqual(response?.data?.count, nil)
                XCTAssertEqual(response?.data?.next, nil)
                XCTAssertEqual(response?.data?.starships?.count, nil)
                expectation.fulfill()
            }
        }
    }

    // This get starships list from mock json file
    // This test is not rely on internet
    func testGetStarshipsListSuccess() {
        let request = ZKGetStarshipsRequest()
        
        // Test the request properties
        XCTAssertEqual(request.api.method, ZKNetworkingAPI.starships(.list).method)
        XCTAssertEqual(request.api.urlString, ZKNetworkingAPI.starships(.list).urlString)
        XCTAssertTrue(request.params == nil)
        XCTAssertEqual(request.timeoutInterval, 10)
        XCTAssertEqual(request.headers, ["content-type": "application/json"])

        // Test send request
        self.responseFileName = "GetStarshipsResponse"
        self.testSendRequest("Test Get Starships List Success") { [unowned self] expectation in
            self.send(request: request) { response, error in
                XCTAssertNil(error)
                // Check the response data
                XCTAssertEqual(response?.data?.count, 36)
                XCTAssertEqual(response?.data?.next, "https://swapi.dev/api/starships/?page=2")
                XCTAssertEqual(response?.data?.starships?.isEmpty, false)
                let firstStarship = response?.data?.starships?.first
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
                XCTAssertEqual(firstStarship?.hyperdriveRating,  "2.0")
                XCTAssertEqual(firstStarship?.MGLT,  "60")
                XCTAssertEqual(firstStarship?.starshipClass,  "corvette")
                XCTAssertEqual(firstStarship?.pilots?.isEmpty, true)
                XCTAssertEqual(firstStarship?.films?.count,  3)
                XCTAssertEqual(firstStarship?.created, "2014-12-10T14:20:33.369000Z")
                XCTAssertEqual(firstStarship?.edited, "2014-12-20T21:23:49.867000Z")
                XCTAssertEqual(firstStarship?.url, "https://swapi.dev/api/starships/2/")
                expectation.fulfill()
            }
        }
    }
    
    func testGetStarshipsListError() {
        let request = ZKGetStarshipsRequest()
        self.responseFileName = "GetStarshipsError"
        self.testSendRequest("Test Get Starships List Error") { [unowned self] expectation in
            self.send(request: request) { response, error in
                XCTAssertNotNil(error)
                XCTAssertNil(response?.data?.starships)
                expectation.fulfill()
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // Implement the ZKNetworkingProtocol
    func send<RequestType>(_ queue: DispatchQueue = DispatchQueue.global(), request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol {
        do {
            // Use mock data from JSON file so the test is not rely on network
            let response = try self.loadResponseFromJSONFile(responseFileName, for: request)
            completion(response, nil)
        } catch let error {
            completion(nil, .custom(message: error.localizedDescription))
        }
    }

    // Load the mock response date from json file
    private func loadResponseFromJSONFile<Request>(_ fileName: String, for request: Request) throws -> Request.ResponseType? where Request: ZKRequestProtocol {
        let path = Bundle(for: type(of:self)).path(forResource: fileName, ofType: "json")
        let url = URL(fileURLWithPath: path ?? "")
        let jsonData = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(Request.ResponseType.self, from: jsonData)
        return response
    }
    
    // Execute the asynchronous request call in the processing closure
    private func testSendRequest(_ name: String, processing: (_ expectation: XCTestExpectation) -> ()) {
        let expectation = self.expectation(description: name)
        processing(expectation)
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
}
