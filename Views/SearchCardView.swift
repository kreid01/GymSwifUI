import SwiftUI


struct SearchCardView: View {
    @State private var suggestions: [Pokemon] = []
    @State private var searchText = "";
    @State private var searchResults: [Card] = [];
    @State private var filteredSuggestions: [Pokemon] = []
    @State private var page = 1;
    
    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    @State private var selectedCard: Card? = nil
    
    @State private var hideNavigationBar = false
       func selectCard(card: Card?) {
           selectedCard = card;
        hideNavigationBar = card != nil;
    }
    
    @State var type: Int = 0
    @State private var generation: Int = 0;
    @State private var subType: Int = 0
    
    var types = ["All Types", "Fire", "Water", "Grass", "Dark", "Fairy",
    "Psychic", "Dragon", "Poision", "Ghost", "Normal", "Fighting",
    "Rock", "Ground"]
    var subTypes = ["All Subtypes", "Mega", "VMax"]
    
    
    @State var sort: Int = 0
    private var sortOptions: [String] = ["None",  "Name (Ascending)", "Name (Descending)", "Type (Ascending)", "Type (Descending)", "Price (Ascending)", "Price (Descending)"]
    
    var sortedSearchResults: [Card] {
        if searchText.isEmpty {
            return sortCards(sort: sort, cards: searchResults)
        } else {
            return sortCards(sort: sort, cards: searchResults)
        }
    }

    var body: some View {
        NavigationStack {
            if !hideNavigationBar {
            VStack {
                HStack {
                    Picker(selection: $type, label: Text("Type")) {
                        ForEach(Array(types.enumerated()), id: \.1) { index, item in
                            Text(item).tag(index)
                        }
                }.onChange(of: type) { _ in
                    searchResults = []
                    search(page: page)
                }
                    Picker(selection: $subType, label: Text("Sub Type")) {
                        ForEach(Array(subTypes.enumerated()), id: \.1) { index, item in
                            Text(item).tag(index)
                        }
                    }.onChange(of: subType) { _ in
                        searchResults = []
                        search(page: page)
                    }

                    Picker(selection: $generation, label: Text("Generation")) {
                        ForEach(0...7, id: \.self) { i in
                            if i == 0 {
                               Text("All Gens")
                            }
                            Text("Gen " + String(i + 1)).tag(i + 1)
                        }
                    }.onChange(of: generation) { _ in
                        searchResults = []
                search(page: page)
            }
                }.frame(width: 1000)
                if searchResults.count > 0 {
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
                }
            }
            ScrollView {
                LazyVGrid(columns:layout) { ForEach(
                    selectedCard != nil ? [selectedCard!] : sortedSearchResults, id: \.self) {
                        card in
                        SingleCard(card: card, handler: selectCard)
                            .task{
                            if card == sortedSearchResults.last {
                                page += 1
                                search(page: page)
                            }
                        }
                    }
                }
            }.scrollDisabled(hideNavigationBar)
                .navigationTitle("")
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .onChange(of: searchText) {
                    page = 1;
                    searchResults = []
                    search(page: page)
                }.searchSuggestions{
                    if searchResults == [] {
                        ForEach(filteredSuggestions, id: \.name) { suggestion in
                        Text(suggestion.name)
                            .searchCompletion(suggestion.name)
                    }
                }}.navigationBarHidden(hideNavigationBar)
        }.onAppear(){
            getPokemon()
        }
    }
    
    private func getPokemon() {
        Task {
            guard let url = URL(string:
                                    "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0")
            else { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
                suggestions = pokemonResponse.results;
            } catch {
                print(error)
            }
        }
    }

    private func search(page: Int) {
        Task {
            let type = self.type == 0 ? "" : "types:\(self.types[type].lowercased()) "
            let subtype = self.subType == 0 ? "" : "subtypes:\(self.subTypes[subType].lowercased()) "
            let generation = self.generation == 0 ? "" : pokedexRange(for: String(self.generation))
            let search = searchText == "" ? "" : "name:\(searchText) "
            
            guard let url = URL(string:
                                    "https://api.pokemontcg.io/v2/cards?q=\(search)\(type)\(subtype)\(generation)&pageSize=50&page=1")
                    
                else { return }
            do {
                print(url)
                let (data, _) = try await URLSession.shared.data(from: url)
                let searchResultsResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                searchResults.append(contentsOf:  searchResultsResponse.data)
                filteredSuggestions = suggestions.filter {  $0.name.lowercased().contains(searchText.lowercased()) }
                
            } catch {
                print(error)
            }
            }
        }
}

func pokedexRange(for generation: String) -> String {
    let generationRanges = [
        "1": [1, 151],
             "2": [152, 251],
             "3": [252, 386],
             "4": [387, 493],
             "5": [494, 649],
             "6": [650, 721],
             "7": [722, 809],
             "8": [810, 905],
             "9": [906, 1010]
    ]
    
    guard let range = generationRanges[generation] else {
        return ""
    }
    
    return "nationalPokedexNumbers:[\(range[0]) TO \(range[1])]"
}



#Preview {
    SearchCardView()
}
