import SwiftUI
import UniformTypeIdentifiers

public struct WishlistView: View {
    var wishlistRepository = WishlistRepository()
    @State var data: [Card] = []

    func refresh() {
        data = wishlistRepository.GetWishlistPokemon()
    }

    func removeFromWishlist(id: String) {
        data = data.filter { $0.id != id }
        wishlistRepository.RemoveFromWishlist(id: id)
    }

    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]

    @State private var inProgress = false
    @State private var isDeleting = false;
    
    @State private var selectedCard: Card?
    
    @State private var hideNavigationBar = false
       func selectCard(card: Card?) {
           selectedCard =  card
        hideNavigationBar = selectedCard != nil;
    }

    public var body: some View {
        NavigationView {
            VStack {
                if !self.hideNavigationBar {
                    Button(action: {
                        self.isDeleting = !isDeleting
                    }, label: {
                        Image(systemName: isDeleting ? "square.and.arrow.down" : "square.and.pencil")
                            .font(.system(size: 28))
                    }).offset(x: 150, y: 0)
                }
                ScrollView {
                    LazyVGrid(columns: layout) {
                        ForEach(
                            selectedCard != nil ? [selectedCard!] : data, id: \.self) { card in
                                ZStack {
                                    SingleCard(card: card, handler: selectCard)
                                        .opacity(isDeleting ? 0.3 : 1.0)
                                    if isDeleting {
                                        Button(action:{ removeFromWishlist(id: card.id)}, label: {
                                            Image(systemName: "trash")
                                                .offset(x: -5, y:-20)
                                                .font(.system(size:32))
                                                .foregroundColor(.red)
                                                .padding()

                                        })
                                    }
                                }
                            }
                    }
                }.scrollDisabled(hideNavigationBar)
                    .navigationBarTitle("Wishlist", displayMode: .inline)
                .navigationBarHidden(hideNavigationBar)
            }
        }
        .refreshable {
            refresh()
        }
        .onAppear {
            refresh()
        }
    }
}

#Preview {
    WishlistView()
}

