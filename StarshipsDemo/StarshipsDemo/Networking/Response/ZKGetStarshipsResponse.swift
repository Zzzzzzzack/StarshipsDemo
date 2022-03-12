//
//  ZKGetStarshipsResponse.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

struct ZKGetStarshipsResponseData: Decodable {
    // Count of all starships
    let count: Int
    // Url String for next page
    let next: String?
    // Url String for previous page
    let previous: String?
    // Starships list
    let starships: [ZKStarship]?
    
    enum CodingKeys: String, CodingKey {
        case count, next, previous
        case starships = "results"
    }
}

struct ZKGetStarshipsResponse: ZKResponseProtocol {
    typealias ResponseDataType = ZKGetStarshipsResponseData
    let data: ResponseDataType?
    
    init(from decoder: Decoder) throws {
        self.data = try ResponseDataType.init(from: decoder)
    }
}
