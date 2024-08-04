import SwiftUI

struct SetView : View {
    let selectedSet: Set
    @State private var searchText = "";
    @StateObject var setViewModel: ViewModel<CardResponse>
    init(set:Set) {
        selectedSet = set
        _setViewModel = StateObject(wrappedValue: ViewModel<CardResponse>(uri: "https://api.pokemontcg.io/v2/cards/?q=set.id:\(set.id)"))
    }
    
    var searchResults: [Card] {
        if searchText.isEmpty {
            return setViewModel.data
        } else {
            return setViewModel.data.filter { $0.name.contains(searchText)}
        }
    }
    
    
    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    @State var sort: Int = 0
    
    var body: some View {
        NavigationStack {
            Menu {
                Picker(selection: $sort, label: Text("Sorting options")) {
                    Text("Name").tag(0)
                    Text("Priority").tag(1)
                }
            } label: {
                Button(action: { print(sort)}) {
                    Text("Sort by")
                    Text(sort == 0 ? "Name" : "Priority")
                    Image(systemName: "arrow.up.arrow.down")
                }
            }.onChange(of: sort) {
                print(sort)
            }
            ScrollView {
                LazyVGrid(columns:layout) { ForEach(searchResults, id: \.self) {
                    card in
                    NavigationLink(destination: CardView(card: card)) {
                        VStack {
                            if let image = card.images?["large"] {
                                URLImage(width: 100, urlString: image)
                            }
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
