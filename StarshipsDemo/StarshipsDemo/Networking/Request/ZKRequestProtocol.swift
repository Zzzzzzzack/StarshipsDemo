//
//  ZKRequestProtocol.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

/// A type of data can be sent through API call
protocol ZKRequestProtocol {
    // The encodable request parameter type, used for decoding the parameters to request body data
    associatedtype ParamsType: Encodable
    // The related response type for the request, it is decodable
    associatedtype ResponseType: ZKResponseProtocol

    // The related api for the request
    var api: ZKNetworkingAPI { get }
    // Request timeout interval
    var timeoutInterval: TimeInterval { get }
    // Request header
    var headers: [String: String] { get }
    // Request parameters
    var params: ParamsType? { get }
}

// Default implementations
extension ZKRequestProtocol {
    // Set the timeout interval to 10 seconds by default
    var timeoutInterval: TimeInterval {
        return 10
    }
    
    // Set up the default headers
    var headers: [String: String] {
        return ["content-type": "application/json"]
    }
}
