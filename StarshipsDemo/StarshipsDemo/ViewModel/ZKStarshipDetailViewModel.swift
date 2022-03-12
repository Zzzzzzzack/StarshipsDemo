//
//  ZKStarshipDetailViewModel.swift
//  StarshipsDemo
//
//  Created by Zack on 12/3/22.
//

import Foundation

class ZKStarshipDetailViewModel {
    @Published var title: String?
    @Published var detail: String?
    
    func update(_ starship: ZKStarship?, detailType: ZKStarshipViewModel.DetailType) {
        // Update the title
        self.title = detailType.rawValue + ":"

        // If starship == nil, set the detail content to nil
        guard let starship = starship else {
            self.detail = nil
            return
        }

        // Update the detail content
        switch detailType {
        case .model:
            self.detail = starship.model
        case .manufacturer:
            self.detail = starship.manufacturer
        case .costInCredits:
            self.detail = starship.costInCredits
        case .length:
            self.detail = starship.length
        case .maxSpeed:
            self.detail = starship.maxSpeed
        case .crew:
            self.detail = starship.crew
        case .passengers:
            self.detail = starship.passengers
        case .cargoCapacity:
            self.detail = starship.cargoCapacity
        case .consumables:
            self.detail = starship.consumables
        case .hyperdriveRating:
            self.detail = starship.hyperdriveRating
        case .MGLT:
            self.detail = starship.MGLT
        case .starshipClass:
            self.detail = starship.starshipClass
        case .pilots:
            self.detail = starship.pilots?.joined(separator: "\n")
        case .films:
            self.detail = starship.films?.joined(separator: "\n")
        case .created:
            self.detail = starship.created
        case .edited:
            self.detail = starship.edited
        }
    }
}
