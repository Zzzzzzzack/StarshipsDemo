//
//  ZKNetworking.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

/// A type can handle the request sending logic
protocol ZKNetworkingProtocol {
    /// Send the request using the related RequestType, response data will be converted to the related instance of ResponseType
    /// - Parameters:
    ///   - queue: The DispatchQueue that used to handling the request and response
    ///   - request: The request instance that implemented the ZKRequestProtocol
    ///   - completion: A callback closure that handles the response and error

    func send<RequestType>(_ queue: DispatchQueue?, request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol
}

/// The default implementation
extension ZKNetworkingProtocol {
    func send<RequestType>(_ queue: DispatchQueue? = nil, request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol {        
    }
}
