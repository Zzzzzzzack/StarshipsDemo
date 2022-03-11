//
//  ZKError.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

/// A list of possible network related errors
protocol ZKError: LocalizedError {

}

/// A list of possible network related errors
enum ZKNetworkingError {
    case invalidURL
    case serverError
    case custom(message: String)
}

/// Implement the ZKError protocol
extension ZKNetworkingError: ZKError {
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .serverError:
            return "Server Error"
        case .custom(let message):
            return message
        }
    }
}
