struct SelectedCardResponse : Codable {
    let data: Card
}

struct Card: Codable, Hashable {
    let  id: String
    let name : String
    let hp: String?
    let types: [String]?
    let images: PokemonImages
    let attacks: [Attack]?
    let number: String
    let tcgplayer: TCGPlayer
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

