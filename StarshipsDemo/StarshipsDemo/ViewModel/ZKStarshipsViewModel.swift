//
//  ZKStarshipsViewModel.swift
//  StarshipsDemo
//
//  Created by Zack on 12/3/22.
//

import Foundation
import Combine

class ZKStarshipsViewModel {
    // A Networking type used to get starships
    var networking: ZKNetworkingProtocol
    
    @Published var starships: [ZKStarship]?
    @Published var errorMessage: String?
    
    /// Initializer
    /// - Parameters:
    ///   - networking: A Networking type used to get starships, it is ZKNetworking by default
    init(_ networking: ZKNetworkingProtocol = ZKNetworking.shared) {
        self.networking = networking
    }
    
    /// Get starships from server
    func getStarships() {
        // Only get the first page at the moment
        // Change the `page` to support paging
        let request = ZKGetStarshipsRequest(params: ZKGetStarshipsRequestParams(page: 1))
        self.networking.send(DispatchQueue.global(), request: request) { [unowned self] in
            self.starships = $0?.data?.starships
            self.errorMessage = $1?.errorDescription
        }
    }
}
