import SwiftUI

struct SetView : View {
    let selectedSet: Set
    @State private var searchText = "";
    @State private var selectedCard: Card?
    @StateObject var setViewModel: ViewModel<CardResponse>
    init(set:Set) {
        selectedSet = set
        _setViewModel = StateObject(wrappedValue: ViewModel<CardResponse>(uri: "https://api.pokemontcg.io/v2/cards/?q=set.id:\(set.id)", saveHandler: Cache.saveCards, cachedData: Cache.getSetCards(setId: set.id)))
    }
    
    var searchResults: [Card] {
        if searchText.isEmpty {
            return sortCards(cards: setViewModel.data)
        } else {
            return sortCards(cards: setViewModel.data.filter { $0.name.contains(searchText)})
        }
    }
    
    @State private var hideNavigationBar = false
       func selectCard(card: Card?) {
        self.selectedCard = card
        hideNavigationBar = card != nil;
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
            if !hideNavigationBar {
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
            }
            if setViewModel.data == [] {Spacer(minLength: 20)
                ProgressView().controlSize(.large)
            }
            ScrollView {
                LazyVGrid(columns:layout) { ForEach(
                    selectedCard != nil ? [selectedCard!] : searchResults, id: \.self) {
                    card in SingleCard(card: card, handler: selectCard)
                    }
                }
    }.scrollDisabled(hideNavigationBar)
            .navigationBarTitle(selectedSet.name, displayMode: .inline)
            .navigationBarHidden(hideNavigationBar)
            .searchable(text: $searchText)
                .onAppear {
                    setViewModel.fetch()
            }
        }
    }
}


#Preview {
    ContentView()
}
