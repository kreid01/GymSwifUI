import SwiftUI

struct SingleCard : View {
    @State var card: Card;
    var handler: (Card?) -> Void
    @State var singleCard: Bool?
    
    var defaultHeight: CGFloat = 200
    var defaultWidth: CGFloat = 100
    
    var wishlistRepository = WishlistRepository()
    var collectionRepository = CollectionRepository()
    
    @State var selected = false;
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0
    @State var height: CGFloat = 200
    @State var width: CGFloat = 100
    
    @State private var prices: [PriceRangeDTO]?
    @State var showPrices = false;
    @State var buttonOffsetX: CGFloat = -400
    
    private func updatePrices() {
            if let tcgPrices = card.tcgplayer?.prices {
               prices =  [PriceRangeDTO(priceRange: tcgPrices.normal, priceName: "Normal"),
                          PriceRangeDTO(priceRange: tcgPrices.holofoil, priceName: "Holofoil"),
                          PriceRangeDTO(priceRange: tcgPrices.reverseHolofoil, priceName: "Reverse Holo")]
            }
    }

    var body: some View {
            VStack {
                CacheAsyncImage(url: URL(string :card.images.large)!, scale: 5.5, desiredWidth: width,
                                desiredHeight: height * 0.65) {
                    phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .empty:
                        ProgressView()
                    case .failure(_):
                        ProgressView()
                    @unknown default:
                        fatalError()
                    }
                }
                    .opacity(showPrices ? 0.3 : 1)
                .onTapGesture {
                    if(!selected) {
                        selected = true
                        handler(self.card)
                        withAnimation {
                            self.height = 800
                            self.width = 350
                            self.offsetX = 115
                            self.offsetY = -55
                        }
                                        
                        withAnimation(.easeInOut(duration: 0.5).delay(0.2))  {
                            self.buttonOffsetX = 0
                        }
                    } else {
                        showPrices = !showPrices
                    }
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
                    }})
                    .zIndex(2)

                if !selected {
                    Text(card.name)
                        .padding()
                        .font(.custom("VT323", size: 12))
                        .foregroundColor(.black)
                }
                
                if selected {
                    VStack {
                        Button("Add to wishlist") {
                            wishlistRepository.AddToWishlist(card: card)
                        }.frame(width: 350, height: 40)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(5)
                            .offset(x: buttonOffsetX, y:0 )
                        Button("Add to collection") {
                            collectionRepository.AddToCollection(card: card)
                        }.frame(width: 350, height: 40)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(5)
                            .offset(x: buttonOffsetX, y:0 )
                        Link("Buy", destination: URL(string: "https://magicmadhouse.co.uk/search.php?search_query=\(card.name)&productFilter=pokémon_set \(card.set.name)")!)
                            .frame(width: 350, height: 40)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(5)
                            .offset(x: buttonOffsetX, y:0)
                    }.offset(x: 0, y: 10)
                }

            }
                    .onAppear{
                        updatePrices()
                    }
            .frame(width: width,height: height).offset(x: offsetX, y: offsetY)
            .gesture(
                                   DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onChanged { value in
                                        if selected {
                                            if value.translation.height > 0 {
                                                if value.translation.height > 350 {
                                                    handler(nil)
                                                    selected = false
                                                    withAnimation {
                                                        self.offsetY = 800
                                                        self.height = defaultHeight;
                                                        self.width = defaultWidth
                                                    }

                                                    withAnimation(.spring(duration :0.3).delay(0.1)) {
                                                        self.offsetY = 0
                                                        self.offsetX = 0
                                                    }
                                                } else {
                                                    withAnimation {
                                                        self.offsetY = value.translation.height
                                                    }
                                                }
                                        }
                                        }})
    }
}



#Preview {
    ContentView()
}


