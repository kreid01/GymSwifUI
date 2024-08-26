import SwiftUI


struct CardView: View {
    var card: Card
    var wishlistRepository = WishlistRepository()
    var collectionRepository = CollectionRepository()
    
    @State private var showPrices = false
    @State private var prices: [PriceRangeDTO]?

    init(card:Card) {
        self.card = card;
    }
    
    private func updatePrices() {
            if let tcgPrices = card.tcgplayer?.prices {
               prices =  [PriceRangeDTO(priceRange: tcgPrices.normal, priceName: "Normal"),
                          PriceRangeDTO(priceRange: tcgPrices.holofoil, priceName: "Holofoil"),
                          PriceRangeDTO(priceRange: tcgPrices.reverseHolofoil, priceName: "Reverse Holo")]
            }
    }
    
        var body: some View {
            NavigationView {
                VStack {
                    URLImage(width: 320, urlString:card.images.large)
                        .opacity(showPrices ? 0.3 : 1)
                        .offset(x: 0, y: -30)
                        .onTapGesture {
                            showPrices = !showPrices;
                        }.overlay(content: {
                            if showPrices {
                                if let prices = prices {
                                    PriceRangeGrid(priceRanges: prices)
                                    .offset(x: 0, y: -30)
                                    .onTapGesture {
                                        showPrices = !showPrices;
                                    }
                                    .frame(width: 400)
                                    .padding()
                                }
                        }
                    })

                    Button("Add to wishlist") {
                        wishlistRepository.AddToWishlist(card: card)
                    }.frame(width: 350, height: 40)
                        .background(.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                    Button("Add to collection") {
                        collectionRepository.AddToCollection(card: card)
                    }.frame(width: 350, height: 40)
                        .background(.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                    Link("Buy", destination: URL(string: "https://magicmadhouse.co.uk/search.php?search_query=\(card.name)&productFilter=pokémon_set \(card.set.name)")!)
                        .frame(width: 350, height: 40)
                        .background(.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                }
            }.navigationBarTitle(card.name, displayMode: .inline)
                .onAppear{
                    updatePrices()
                }
        }
    }


#Preview {
    ContentView()
}
