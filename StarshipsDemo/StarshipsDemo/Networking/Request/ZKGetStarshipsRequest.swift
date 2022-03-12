//
//  ZKGetStarshipsRequest.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

struct ZKGetStarshipsRequestParams: Encodable {
    // Start from 1
    // If this value equals to nil, means load the first page
    let page: Int? = nil
}

struct ZKGetStarshipsRequest: ZKRequestProtocol {
    typealias ParamsType = ZKGetStarshipsRequestParams
    typealias ResponseType = ZKGetStarshipsResponse
    
    var api: ZKNetworkingAPI {
        return .starships(.list)
    }
    
    // This API can be call without parameters
    let params: ParamsType? = nil
}
