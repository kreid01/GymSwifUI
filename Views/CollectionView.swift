import SwiftUI

public struct CollectionView : View {
    var collectionRepository = CollectionRepository();
    @State var data: [Card] = []
    
    func refresh() {
        data = collectionRepository.GetCollectionPokemon()
    }
    
    func removeFromCollection(card: Card) {
        data = data.filter { $0.id != card.id }
        collectionRepository.RemoveFromCollection(card: card)
    }

    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    @State private var inProgress = false
    @State private var isDragging = false;

    public var body :  some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns:layout) { ForEach(data, id: \.self) {
                        card in
                        NavigationLink(destination: CardView(card: card)) {
                            VStack {
                                URLImage(width: 100, urlString: card.images.large)
                                Text(card.name)
                                    .padding()
                                    .font(.system(size: 12))
                            }
                            .frame(height:200)
                            .draggable(card)
                        }
                    }
                    }
                }
                .navigationTitle("Collection")
                    
                    
                    if isDragging == false {TrashView(handler: removeFromCollection(card:), inProgress: inProgress)}

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
