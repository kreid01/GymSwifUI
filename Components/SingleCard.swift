import SwiftUI

struct SingleCard: View {
    @State var card: Card
    var handler: (Card?) -> Void
    @State var singleCard: Bool?

    var defaultHeight: CGFloat = 200
    var defaultWidth: CGFloat = 100

    var wishlistRepository = WishlistRepository()
    var collectionRepository = CollectionRepository()

    @State var selected = false
    @State var offsetX: CGFloat = 50
    @State var offsetY: CGFloat = 100
    @State var height: CGFloat = 200
    @State var width: CGFloat = 100

    @State private var prices: [PriceRangeDTO]?
    @State var showPrices = false

    private func updatePrices() {
        if let tcgPrices = card.tcgplayer?.prices {
            prices = [PriceRangeDTO(priceRange: tcgPrices.normal, priceName: "Normal"),
                      PriceRangeDTO(priceRange: tcgPrices.holofoil, priceName: "Holofoil"),
                      PriceRangeDTO(priceRange: tcgPrices.reverseHolofoil, priceName: "Reverse Holo")]
        }
    }

    var body: some View {
        VStack {
            CacheAsyncImage(url: URL(string: card.images.large)!, scale: 5.5, desiredWidth: width,
                            desiredHeight: height * 0.65)
            {
                phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                case .empty:
                    ProgressView()
                case .failure:
                    ProgressView()
                @unknown default:
                    fatalError()
                }
            }
            .opacity(showPrices ? 0.3 : 1)
            .onTapGesture {
                if !selected {
                    selected = true
                    handler(self.card)
                    withAnimation {
                        self.height = 800
                        self.width = 350
                        self.offsetX = 175
                        self.offsetY = 320
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
                                showPrices = !showPrices
                            }
                            .frame(width: 400)
                            .padding()
                    }
                    if let image = card.set.images["logo"] {
                        CacheAsyncImage(url: URL(string: image)!) {
                            phase in
                            switch phase {
                            case .success(let image):
                                NavigationLink(destination: SetView(set: card.set), label: { image.resizable().scaledToFit()
                                        .frame(width: 300)
                                })
                            case .empty:
                                ProgressView()
                            case .failure:
                                ProgressView()
                            @unknown default:
                                fatalError()
                            }
                        }
                    }
                }
            })
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
                }.offset(x: 0, y: 10)
            }
        }
        .onAppear {
            updatePrices()
        }
        .frame(width: width, height: height).position(x: offsetX, y: offsetY)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded { value in
                    if selected {
                        if value.translation.height > 400 {
                            handler(nil)
                            selected = false
                            withAnimation {
                                self.offsetY = 800
                                self.height = defaultHeight
                                self.width = defaultWidth
                            }

                            withAnimation(.spring(duration: 0.3).delay(0.1)) {
                                self.offsetY = 100
                                self.offsetX = 50
                            }
                        } else {
                            withAnimation {
                                self.offsetY = 320
                            }
                        }
                    }
                }
                .onChanged { value in
                    self.showPrices = false
                    if selected {
                        if value.translation.height > 0 {
                            withAnimation {
                                self.offsetY = 320 + value.translation.height
                            }
                        }
                    }
                })
    }
}

#Preview {
    ContentView()
}
