import SwiftUI



struct SetView : View {
    let selectedSet: Set
    @State private var searchText = "";
    @StateObject var setViewModel: ViewModel<CardResponse>
    init(set:Set) {
        selectedSet = set
        _setViewModel = StateObject(wrappedValue: ViewModel<CardResponse>(uri: "https://api.pokemontcg.io/v2/cards/?q=set.id:\(set.id)", saveHandler: Cache.saveCards, getHandler: Cache.getCards))
    }
    
    var searchResults: [Card] {
        if searchText.isEmpty {
            return sortCards(cards: setViewModel.data)
        } else {
            return sortCards(cards: setViewModel.data.filter { $0.name.contains(searchText)})
        }
    }
    
    func sortCards(cards: [Card]) -> [Card]  {
        var newCards = cards;
        if sort == 0 { return newCards}
        newCards.sort {
            if sort == 1 {
                return  $0.name < $1.name
            }
            if sort == 2 {
                return  $0.name > $1.name
            }
            if sort == 5 {
                if let type1 = $0.types?[0], let type2 = $1.types?[0] {
                    return type1 < type2
                }
            }
            else {
                if let type1 = $0.types?[0], let type2 = $1.types?[0] {
                    return type1 > type2
                }
            }
            
            return true
        }
        return newCards
    }
    
    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    @State var sort: Int = 0
    private var sortOptions: [String] = ["None", "Name (Ascending)", "Name (Descending)", "Type (Ascending)", "Type (Descending)"]
    
    var body: some View {
        NavigationStack {
            Menu {
                Picker(selection: $sort, label: Text("Sorting options")) {
                    ForEach(Array(sortOptions.enumerated()), id: \.1) { index, item in
                            Text(item).tag(index)
                        }
                }
            } label: {
                Button(action: { print(sort)}) {
                    Text("Sort by")
                    Text(sortOptions[sort])
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            ScrollView {
                LazyVGrid(columns:layout) { ForEach(searchResults, id: \.self) {
                    card in
                    NavigationLink(destination: CardView(card: card)) {
                        VStack {
                            URLImage(width: 100, urlString: card.images.large)
                            Text(card.name).padding().font(.system(size: 12))
                        }.frame(height:200)
                    }
            }
        }
    }
            .navigationTitle(selectedSet.name).searchable(text: $searchText)
                .onAppear {
                    setViewModel.fetch()
            }
        }
    }
}

#Preview {
    ContentView()
}
