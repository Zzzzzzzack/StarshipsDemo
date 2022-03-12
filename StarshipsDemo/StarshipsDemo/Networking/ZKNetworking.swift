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
    ///   - queue: The DispatchQueue that used to execute the API call
    ///   - request: The request instance that implemented the ZKRequestProtocol
    ///   - completion: A callback closure that handles the response and error
    func send<RequestType>(_ queue: DispatchQueue, request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol
}

class ZKNetworking: ZKNetworkingProtocol {
    static let shared = ZKNetworking()
}

/// Implementation the ZKNetworkingProtocol
extension ZKNetworking {
    /// Send the request using the related RequestType, response data will be converted to the related instance of ResponseType
    /// - Parameters:
    ///   - queue: The DispatchQueue that used to execute the API call, by default it is global queue
    ///   - request: The request instance that implemented the ZKRequestProtocol
    ///   - completion: A callback closure that handles the response and error
    func send<RequestType>(_ queue: DispatchQueue = DispatchQueue.global(), request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol {
        
        // Validate the URL string
        guard var urlComponents = URLComponents(string: request.api.urlString) else {
            // If the URL string is invalid, complete the API call with error
            completion(nil, .invalidURL)
            return
        }
        
        if request.api.method == .get {
            // If the the http method is GET, convert the parameters to query items
            do {
                urlComponents.queryItems = try request.params?.convertToQueryItems()
            } catch let error {
                // If the conversion failed, complete the API call with error
                completion(nil, .custom(message: error.localizedDescription))
                return
            }
        }
        
        guard let url = urlComponents.url else {
            // If the URL is invalid call, complete the API call with error
            completion(nil, .invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: request.timeoutInterval)
        
        if (request.api.method == .post) {
            // If the http method is POST, convert the parameters to http body
            do {
                urlRequest.httpBody = try JSONEncoder().encode(request.params)
            } catch let error {
                // If the conversion failed, complete the API call with error
                completion(nil, .custom(message: error.localizedDescription))
                return
            }
        }
        
        urlRequest.httpMethod = request.api.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        // Create the API call task
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                // If error is not nil, complete the API call with error
                queue.async {
                    completion(nil, .custom(message: error.localizedDescription))
                }
                return
            }
            
            guard let data = data, let urlResponse = urlResponse as? HTTPURLResponse else {
                // Invalid response data, complete the API call with error
                queue.async { completion(nil, .invalidURL) }
                return
            }
            
            if urlResponse.statusCode == 400 {
                // Complete the API call with server error
                queue.async {
                    completion(nil, .serverError)
                }
            } else if 200...299 ~= urlResponse.statusCode {
                do {
                    let response = try JSONDecoder().decode(RequestType.ResponseType.self, from: data)
                    queue.async {
                        // Complete the API call with eligible response data
                        completion(response, nil)
                    }
                } catch let responseError {
                    // Complete the API call with decoding error
                    queue.async {
                        completion(nil, .custom(message: responseError.localizedDescription))
                    }
                }
            } else {
                // Complete the API call with unknown error
                queue.async { completion(nil, .custom(message: "Unknown Error")) }
            }
        }
        
        // Start the API call task
        task.resume()
    }
}

/// The private extension used to convert Encodable instance to dictionary and query items
private extension Encodable {
    /// Convert the Encodable instance to dictionary
    func convertToDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return jsonObject as? [String: Any]
    }
    
    /// Convert the Encodable instance to query items
    func convertToQueryItems() throws -> [URLQueryItem]? {
        let dict = try self.convertToDictionary()
        return dict?.compactMap { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
}
