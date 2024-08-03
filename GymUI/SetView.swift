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
    let hp: String
    let types: [String]
    let images: PokemonImages
    let attacks: [Attack]
    let number: String
}

struct TCGPlayer : Codable{
    let url : String
    let prices: Prices?
}

struct Prices: Codable {
    let holofoil: [String: Int]
}

struct PriceRange: Codable {
    let low : Int
    let mid : Int
    let high : Int
    let market : Int
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

import SwiftUI

struct CardView: View {
    var selectedCard: Card
    @StateObject var cardViewModel: CardViewModel
    
    init(card:Card) {
        self.selectedCard = card;
        _cardViewModel = StateObject(wrappedValue: CardViewModel(uri: "https://api.pokemontcg.io/v2/cards/\(card.id)"))
    }
    
    
    var body : some View {
        NavigationView {
            if let image = cardViewModel.selectedCard?.images.large {
                URLImage(width: 350,urlString: image )
            }
            Text(selectedCard.name).padding().font(.system(size: 20))
        }.navigationTitle(selectedCard.name).onAppear {
            cardViewModel.fetch()
        }
    }
}

struct SetView : View {
    let selectedSet: Set
    @StateObject var setViewModel: ViewModel<CardResponse>
    init(set:Set) {
        selectedSet = set
        _setViewModel = StateObject(wrappedValue: ViewModel<CardResponse>(uri: "https://api.pokemontcg.io/v2/cards/?q=set.id:\(set.id)"))
    }

    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns:layout) {
                    ForEach($setViewModel.data, id: \.self) {
                        $card in
                        NavigationLink(destination: CardView(card: card)) {
                            VStack {
                                if let image = card.images?["large"] {
                                    URLImage(width: 100, urlString: image)
                                }
                                Text(card.name).padding().font(.system(size: 12))
                            }.frame(height:200)
                        }
                    }
                }
            }
        }.navigationTitle(selectedSet.name).padding(.horizontal)
                    .onAppear {
                        setViewModel.fetch()
                    
        }
    }
}
