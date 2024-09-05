import SwiftUI


public struct CollectionView : View {
    var collectionRepository = CollectionRepository();
    var collectionValueUtils = CollectionValueUtils();
    
    @State var data: [Card] = []
    @State var collectionValue:  CollectionValue?;
    
    func refresh() {
        data = collectionRepository.GetCollectionPokemon()
        collectionValue = collectionValueUtils.getCollectionValue(cards: data)
    }
    
    func removeFromCollection(id: String) {
        data = data.filter { $0.id != id }
        collectionRepository.RemoveFromCollection(id: id)
        collectionValue = collectionValueUtils.getCollectionValue(cards: data)
    }

    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    @State private var inProgress = false
    @State private var isDeleting = false;
    @State private var viewingTotals = false;
    
    @State private var selectedCard: Card?
    
    @State private var hideNavigationBar = false
       func selectCard(card: Card?) {
           selectedCard = card;
        hideNavigationBar = card != nil;
    }

    public var body :  some View {
        NavigationView {
            VStack {
                if !self.hideNavigationBar {
                    HStack {
                        Button(action: {
                            self.isDeleting = !isDeleting
                        }, label: {
                            Image(systemName: isDeleting ? "square.and.arrow.down" : "square.and.pencil")
                                .font(.system(size: 28))
                        })
                        Button(action: {
                            self.viewingTotals = !viewingTotals
                        }, label: {
                            Image(systemName: viewingTotals ? "eye.slash" : "eye")
                                .font(.system(size: 28))
                    })
                    }.offset(x: 130, y: 0)
                }
                ZStack {
                    if viewingTotals {
                        if let estimatedTotals = collectionValue?.estimatedTotals
                        {
                            PriceRangeGrid(priceRanges: estimatedTotals)
                                .zIndex(1.0)
                        }
                    }
                    
                    VStack {
                        if !viewingTotals {
                            ScrollView {
                                LazyVGrid(columns:layout) {  ForEach(
                                    selectedCard != nil ? [selectedCard!] : data, id: \.self) { card in
                                        ZStack {
                                            SingleCard(card: card, handler: selectCard)
                                                .opacity(isDeleting ? 0.3 : 1.0)
                                            if isDeleting {
                                                Button(action:{ removeFromCollection(id: card.id)}, label: {
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
                            }
                            .offset(x: 0, y: 20)
                            .scrollDisabled(hideNavigationBar)
                        }
                    }.navigationBarTitle("Collection", displayMode: .inline)
                        .navigationBarHidden(hideNavigationBar)
                    
                }.refreshable {
                    refresh()
                }.onAppear(perform: {
                    refresh();
                })
                
            }
        }
    }
}

#Preview {
    CollectionView()
}
