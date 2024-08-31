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
    let tcgplayer: TCGPlayer?
    let number: String
    let set: Set
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .card)
    }
}

extension UTType  {
    static let card = UTType(exportedAs: "Swift1.GymUI.card")
}

struct TCGPlayer : Codable, Hashable {
    let url : String?
    let prices: Prices?
}

struct Prices: Codable, Hashable  {
    let holofoil: PriceRange?
    let normal: PriceRange?
    let reverseHolofoil: PriceRange?
}
struct PriceRange: Codable , Hashable {
    let low : Float?
    let mid : Float?
    let high : Float?
    let market : Float?
}

struct PriceRangeDTO: Hashable, Identifiable {
    var id = UUID()
    let lowString: String;
    let midString: String
    let highString: String
    let marketString: String
    let name: String
    
    init(priceRange: PriceRange?, priceName: String) {
        lowString = String(priceRange?.low ?? 0)
        midString = String(priceRange?.mid ?? 0)
        highString = String(priceRange?.high ?? 0)
        marketString = String(priceRange?.market ?? 0)
        name = priceName;
    }
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

