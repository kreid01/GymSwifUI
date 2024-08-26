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
    
    func removeFromCollection(card: Card) {
        data = data.filter { $0.id != card.id }
        collectionRepository.RemoveFromCollection(card: card)
        collectionValue = collectionValueUtils.getCollectionValue(cards: data)
    }

    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    @State private var inProgress = false
    @State private var isDragging = false;
    @State private var viewingTotals = false;
    
    @State private var selectedCard: Card?
    
    @State private var hideNavigationBar = false
       func selectCard(card: Card?) {
           selectedCard = card;
        hideNavigationBar = card != nil;
    }

    public var body :  some View {
        NavigationView {
                ZStack {
                    if viewingTotals {
                        if let estimatedTotals = collectionValue?.estimatedTotals
                        {
                            PriceRangeGrid(priceRanges: estimatedTotals)
                          .zIndex(1.0)
                            
                            Button("Hide") {
                            viewingTotals = !viewingTotals
                            }.frame(width: 350, height: 40)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(5)
                            .zIndex(2.0)
                            .offset(x: 0, y: -340)
                        }
                    }
                    
                    VStack {
                        if !hideNavigationBar && !viewingTotals {
                            Button("Show Value") {
                            viewingTotals = !viewingTotals
                            }.frame(width: 350, height: 40)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(5)
                            .zIndex(2.0)
                        }

                        if !viewingTotals {
                            ScrollView {
                                LazyVGrid(columns:layout) { ForEach(
                                    selectedCard != nil ? [selectedCard!] : data, id: \.self) {
                                    card in
                                    SingleCard(card: card, handler: selectCard)
                                        .draggable(card)
                                }
                            }
                            }.offset(x: 0, y: 20)
                                .scrollDisabled(hideNavigationBar)
                        }
                }.navigationBarTitle("Collection", displayMode: .inline)
                .navigationBarHidden(hideNavigationBar)


                    if !hideNavigationBar {TrashView(handler: removeFromCollection(card:), inProgress: inProgress)}
                    }
               
            }.refreshable {
                    refresh()
                }.onAppear(perform: {
                    refresh();
                })

    }
}

#Preview {
    CollectionView()
}
