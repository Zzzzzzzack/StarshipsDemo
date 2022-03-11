//
//  ZKNetworkingAPI.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

private let domain = "https://swapi.dev/api"

/// Methods of http request
enum ZKHttpMethod: String {
    case get, post
}

/// A type that can be used to get the API's url string and its related http method
protocol ZKNetworkingAPIProtocol {
    // The full API url string, e.g. https://swapi.dev/api/starships/2",
    var urlString: String { get }
    
    // The related http method of this API
    var method: ZKHttpMethod { get }
}
   
// A enum used to get the Networking API info
enum ZKNetworkingAPI {
    // Define the API categories
    case starships(_ api: ZKNetworkingAPI.Category.Starships)
    
    // The category used for grouped the APIs
    // Use subclass here so it can only been used by this formate: ZKNetworkingAPI.Category
    class Category {}
}

// Implement the ZKNetworkingAPIProtocol for all the APIs
extension ZKNetworkingAPI: ZKNetworkingAPIProtocol {
    var urlString: String {
        switch self {
        case .starships(let api):
            return domain + "/" + api.categoryName + "/" + api.apiName
        }
    }
    
    var method: ZKHttpMethod {
        switch self {
        case .starships(let api):
            return api.method
        }
    }
}

// Define the APIs under the starship category
extension ZKNetworkingAPI.Category {
    enum Starships {
        case list
        case details(_ starshipID: String)
    }
}

// Define the category names, API names and http methods for Starships APIs
extension ZKNetworkingAPI.Category.Starships {
    // API category name
    var categoryName: String {
        return "starships"
    }
    
    // API name
    var apiName: String {
        switch self {
        case .list:
            return ""
        case .details(let starshipID):
            return "\(starshipID)"
        }
    }
    
    // Related http method
    var method: ZKHttpMethod {
        switch self {
        case .list, .details:
            return .get
        }
    }
}
