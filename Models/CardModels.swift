import SwiftUI
import UniformTypeIdentifiers

struct SelectedCardResponse : Codable {
    let data: Card
}

struct Card: Codable, Hashable, Transferable {
    let  id: String
    let name : String
    let hp: String?
    let types: [String]?
    let images: PokemonImages
    let attacks: [Attack]?
    let number: String
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .card)
    }
}

extension UTType  {
    static let card = UTType(exportedAs: "Swift1.GymUI.card")
}

struct TCGPlayer : Codable, Hashable {
    let url : String
    let prices: Prices?
}

struct Prices: Codable , Hashable {
    let holofoil: PriceRange?
    let normal : PriceRange?
    let reverseHolofoil: PriceRange?
}

struct PriceRange: Codable , Hashable {
    let low : Float
    let mid : Float
    let high : Float
    let market : Float
}

struct PokemonImages: Codable, Hashable {
    let small : String
    let large : String
}

struct Attack: Codable , Hashable{
    let name : String;
    let cost : [String]
    let damage : String
    let convertedEnergyCost: Int;
    let text: String

}

