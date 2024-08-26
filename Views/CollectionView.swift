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

    public var body :  some View {
        NavigationView {
                ZStack {
                    if viewingTotals {
                        if let estimatedTotals = collectionValue?.estimatedTotals
                        {
                            PriceRangeGrid(priceRanges: estimatedTotals)
                          .zIndex(1.0)
                        }
                    }
                    ScrollView {
                        LazyVGrid(columns:layout) { ForEach(data, id: \.self) {
                            card in
                            VStack {
                                SingleCard(card: card)
                                    .frame(height:200)
                                    .draggable(card)
                                }
                            }
                        }
                    }
                    .navigationBarTitle("Collection", displayMode: .inline)
                        if isDragging == true {TrashView(handler: removeFromCollection(card:), inProgress: inProgress)}

                    }
                }.refreshable {
                    refresh()
                }.onAppear(perform: {
                    refresh();
                })
            Button(viewingTotals ? "Hide" : "Show Value") {
                viewingTotals = !viewingTotals
            }.frame(width: 350, height: 40)
                .background(.yellow)
                .foregroundColor(.black)
                .cornerRadius(5)
            
          
    }
}

#Preview {
    CollectionView()
}
