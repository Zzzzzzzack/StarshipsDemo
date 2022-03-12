//
//  ZKStarship.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import Foundation

struct ZKStarship: Decodable {
    let name: String?
    let model: String?
    let manufacturer: String?
    let costInCredits: String?
    let length: String?
    let maxSpeed: String?
    let crew: String?
    let passengers: String?
    let cargoCapacity: String?
    let consumables: String?
    let hyperdriveRating: String?
    let MGLT: String?
    let starshipClass: String?
    let pilots: [String]?
    let films: [String]?
    let created: String?
    let edited: String?
    let url: String?
    
    let isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name, model, manufacturer, length, crew, passengers, consumables, MGLT, pilots, films, created, edited, url
        case costInCredits = "cost_in_credits"
        case maxSpeed = "max_atmosphering_speed"
        case cargoCapacity = "cargo_capacity"
        case hyperdriveRating = "hyperdrive_rating"
        case starshipClass = "starship_class"
    }
}
