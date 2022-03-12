//
//  ZKStarshipViewModel.swift
//  StarshipsDemo
//
//  Created by Zack on 12/3/22.
//

import Foundation
import Combine

class ZKStarshipViewModel {
    private var starship: ZKStarship?
    @Published var name: String?
    @Published var model: String?
    @Published var manufacturer: String?
    @Published var costInCredits: String?
    @Published var length: String?
    @Published var maxSpeed: String?
    @Published var crew: String?
    @Published var passengers: String?
    @Published var cargoCapacity: String?
    @Published var consumables: String?
    @Published var hyperdriveRating: String?
    @Published var MGLT: String?
    @Published var starshipClass: String?
    @Published var pilots: [String]?
    @Published var films: [String]?
    @Published var created: String?
    @Published var edited: String?
    @Published var url: String?
    @Published var isFavorite: Bool?

    /// Update the view model by starship
    func update(_ starship: ZKStarship) {
        self.starship = starship
        self.name = starship.name
        
        if let model = starship.model {
            self.model = "Model: " + model
        } else {
            self.model = nil
        }
        
        if let manufacturer = starship.manufacturer {
            self.manufacturer  = "Manufacturer: " + manufacturer
        } else {
            self.manufacturer = nil
        }
        
        self.costInCredits = starship.costInCredits
        self.length = starship.length
        self.maxSpeed = starship.maxSpeed
        self.crew = starship.crew
        self.passengers = starship.passengers
        self.cargoCapacity = starship.cargoCapacity
        self.consumables = starship.consumables
        self.hyperdriveRating = starship.hyperdriveRating
        self.MGLT = starship.MGLT
        self.starshipClass = starship.starshipClass
        self.pilots = starship.pilots
        self.films = starship.films
        self.pilots = starship.pilots
        self.created = starship.created
        self.edited = starship.edited
        self.url = starship.url
        self.isFavorite = starship.isFavorite
    }
}
