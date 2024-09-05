import SwiftUI

struct SetView : View {
    let selectedSet: Set
    @State private var searchText = "";
    @State private var page = 1;
    @State private var selectedCard: Card?
    @StateObject var setViewModel: ViewModel<CardResponse>
    init(set:Set) {
        selectedSet = set
        _setViewModel = StateObject(wrappedValue: ViewModel<CardResponse>(uri: "https://api.pokemontcg.io/v2/cards/?q=set.id:\(set.id)", saveHandler: Cache.saveCards, cachedData: Cache.getSetCards(setId: set.id)))
    }
    
    var searchResults: [Card] {
        if searchText.isEmpty {
            return sortCards(sort: sort, cards: setViewModel.data)
        } else {
            return sortCards(sort: sort, cards: setViewModel.data.filter { $0.name.contains(searchText)})
        }
    }
    
    @State private var hideNavigationBar = false
       func selectCard(card: Card?) {
        self.selectedCard = card
        hideNavigationBar = card != nil;
    }

 
    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    @State var sort: Int = 0
    private var sortOptions: [String] = ["None",  "Name (Ascending)", "Name (Descending)", "Type (Ascending)", "Type (Descending)", "Price (Ascending)", "Price (Descending)"]
    
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
                        card in SingleCard(card: card, handler: selectCard).task {
                            if card == setViewModel.data.last {
                                page += 1
                                 setViewModel.fetchMore(page: page)
                            }
                        }
                    }
                }
    }.scrollDisabled(hideNavigationBar)
            .navigationBarTitle(selectedSet.name, displayMode: .inline)
            .navigationBarHidden(hideNavigationBar)
            .searchable(text: $searchText)
                .onAppear {
                    setViewModel.fetchMore(page:page)
            }
        }
    }
}


#Preview {
    ContentView()
}
