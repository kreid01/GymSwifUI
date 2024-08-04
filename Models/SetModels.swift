protocol DataContainer: Decodable {
    associatedtype DataType: Decodable & Hashable
    var data: [DataType] { get }
}

struct SetResponse: DataContainer ,Hashable  {
    var data: [Set]
}

struct CardResponse: DataContainer, Hashable {
    var data: [Card]
}

struct Set: Hashable, Codable {
    let id: String
    let name: String;
    let series: String;
    let printedTotal : Int;
    let releaseDate: String
    let images: [String: String]
}

struct SetImage: Codable {
    let symbol: String;
    let logo: String
}
