struct Card: Hashable,  Codable {
    let  id: String
    let name : String
    let hp: String?
    let types: [String]?
    let images : [String: String]?
}

struct SelectedCardResponse : Codable {
    let data: SelectedCard
}

struct SelectedCard: Codable {
    let  id: String
    let name : String
    let hp: String?
    let types: [String]?
    let images: PokemonImages
    let attacks: [Attack]?
    let number: String
    let tcgplayer: TCGPlayer?
}

struct TCGPlayer : Codable{
    let url : String
    let prices: Prices?
}

struct Prices: Codable {
    let holofoil: PriceRange?
    let normal : PriceRange?
    let reverseHolofoil: PriceRange?
}

struct PriceRange: Codable {
    let low : Float
    let mid : Float
    let high : Float
    let market : Float
}

struct PokemonImages: Codable {
    let small : String
    let large : String
}

struct Attack: Codable {
    let name : String;
    let cost : [String]
    let damage : String
    let convertedEnergyCost: Int;
    let text: String

}

