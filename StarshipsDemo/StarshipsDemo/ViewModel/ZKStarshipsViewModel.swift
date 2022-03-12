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
    
    var starships: [ZKStarship]?
    
    @Published var reloadData: Bool?
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
            self.reloadData = true
            self.errorMessage = $1?.errorDescription 
            
            if let starships = self.starships {
                // Save the list to DB
                ZKStarshipsDBHelper.shared.batchSaveOrUpdate(starships)
            }
        }
    }
    
    /// Toggle favourite for existing starship
    func toggleFavourite(_ starship: ZKStarship?) {
        // Find the existing starship by matched name
        if let starships = self.starships, let starship = starship, let index = starships.firstIndex(where: {
            return $0.name == starship.name
        }) {
            let existingStarship = starships[index]
            // Toggle the favourite status
            let isFavourite = !existingStarship.isFavourite
            self.starships?[index].isFavourite = isFavourite
            
            // Save the changes into DB
            if let updatingStarships = self.starships?[index] {
                ZKStarshipsDBHelper.shared.saveOrUpdate(updatingStarships)
            }
        }
    }
}
