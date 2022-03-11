//
//  ZKResponseProtocol.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

/// A type of data that received from the API call
protocol ZKResponseProtocol: Decodable {
    // A Decodable Response data type
    associatedtype ResponseDataType: Decodable
    // Response data. If request failure, this value = nil
    var data: ResponseDataType? { get }
}
