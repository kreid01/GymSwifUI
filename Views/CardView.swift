import SwiftUI

struct CardView: View {
    var card: Card
    var wishlistRepository = WishlistRepository()
    var collectionRepository = CollectionRepository()
    @StateObject var cardViewModel: CardViewModel
    
    init(card:Card) {
        self.card = card;
        _cardViewModel = StateObject(wrappedValue: CardViewModel(uri: "https://api.pokemontcg.io/v2/cards/\(card.id)"))
    }
    
    
        var body: some View {
            NavigationView {
                VStack {
                    if let selectedCard = cardViewModel.selectedCard {
                        Text(selectedCard.name)
                        URLImage(width: 350, urlString:selectedCard.images.large)

                       // if let prices = selectedCard.tcgplayer?.prices {
                         //   if let normal = prices.normal {
                           //     Text("Normal high: \(normal.high)")
                             //   Text("Normal mid: \(normal.mid)")
              //                  Text("Normal low: \(normal.low)")
                   //         }
//
                    //        if let holo = prices.holofoil {
                    //            Text("Holo high: \(holo.high)")
                    //            Text("Holo mid: \(holo.mid)")
                    //            Text("Holo low: \(holo.low)")
                    //        }
                      //  }

                        Button("Add to wishlist") {
                            wishlistRepository.AddToWishlist(card: selectedCard)
                        }
                        Button("Add to collection") {
                            collectionRepository.AddToCollection(card: selectedCard)
                        }

                    } else {
                        ProgressView("Loading...")
                    }
                }
                .navigationTitle("")
                .onAppear {
                    cardViewModel.fetch()
                }
            }
        }
    }


#Preview {
    ContentView()
}
