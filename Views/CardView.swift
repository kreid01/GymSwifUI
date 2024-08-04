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
            VStack {
                if let image = cardViewModel.selectedCard?.images.large {
                    URLImage(width: 350,urlString: image )
                }
                
                if let prices = cardViewModel.selectedCard?.tcgplayer?.prices {
                    if let normal = prices.normal {
                        Text("Normal high: " + String(normal.high))
                        Text("Normal mid:" + String(normal.mid))
                        Text("Normal low" + String(normal.low))
                    }
                    

                    if let holo = prices.holofoil {
                        Text("Holo high: " + String(holo.high))
                        Text("Holo mid: " + String(holo.mid))
                        Text("Holo low: " + String(holo.low))
                    }
                }
            }
        }.navigationTitle(selectedCard.name).onAppear {
            cardViewModel.fetch()
        }
    }
}

