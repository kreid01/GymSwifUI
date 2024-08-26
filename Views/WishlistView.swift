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
    
    @State private var selectedCard: Card?
    
    @State private var hideNavigationBar = false
       func selectCard(card: Card?) {
           selectedCard =  card
        hideNavigationBar = selectedCard != nil;
    }

    public var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: layout) {
                        ForEach(
                            selectedCard != nil ? [selectedCard!] : data, id: \.self) { card in
                            SingleCard(card: card, handler: selectCard)
                                .draggable(card)
                        }
                    }
                }.scrollDisabled(hideNavigationBar)
                .navigationBarTitle("Wishlist", displayMode: .inline)
                .navigationBarHidden(hideNavigationBar)

                if !hideNavigationBar {TrashView(handler: removeFromWishlist(card:), inProgress: inProgress)}
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
                .font(.system(size: 28))
                .padding()
                .background(inProgress ? Color.red.opacity(0.5) : .red.opacity(0.3))
                .cornerRadius(5)
                .offset(x: 0, y: -50)
        }
    }
}

#Preview {
    WishlistView()
}
