import SwiftUI

public struct WishlistView: View {
    var wishlistRepository = WishlistRepository()
    @State var data: [Card] = []

    func refresh() {
        data = wishlistRepository.GetWishlistPokemon()
    }

    func removeFromWishlist(card: Card) {
        data = data.filter { $0.id != card.id }
        wishlistRepository.RemoveFromWishlist(card: card)
    }

    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]

    @State private var inProgress = false
    @State private var isDragging = false;

    public var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: layout) {
                        ForEach(data, id: \.self) { card in
                            NavigationLink(destination: CardView(card: card)) {
                                VStack {
                                    URLImage(width: 100, urlString: card.images.large)
                                    Text(card.name)
                                        .padding()
                                        .font(.system(size: 12))
                                }
                              
                                .frame(height: 200)
                                .draggable(card)
                            }
                        }
                    }
                }
                .navigationTitle("Wishlist")

                if isDragging == false {TrashView(handler: removeFromWishlist(card:), inProgress: inProgress)}
            }
        }.refreshable {
            refresh()
        }
        .onAppear {
            refresh()
        }
    }
}

public struct TrashView : View {
    var handler: (Card) -> Void
    @State public var inProgress: Bool;
    
    
    public var body: some View {
        VStack {
            Spacer()
            Image(systemName: "trash")
                .dropDestination(for: Card.self) { droppedCards, location in
                    handler(droppedCards[0])
                    return true
                } isTargeted: { isTargeted in
                    inProgress = isTargeted
                }
                .foregroundColor(.red)
                .font(.system(size: 40))
                .padding()
                .background(inProgress ? Color.red.opacity(0.5) : .red.opacity(0.3))
                .cornerRadius(5)
        }
    }
}

#Preview {
    WishlistView()
}
