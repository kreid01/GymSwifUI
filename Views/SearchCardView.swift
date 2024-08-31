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
    
    @Environment(\.dismissSearch) private var dismissSearch

    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns:layout) { ForEach(
                    selectedCard != nil ? [selectedCard!] : searchResults, id: \.self) {
                        card in
                        SingleCard(card: card, handler: selectCard)
                            .task{
                            if card == searchResults.last {
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
            print(searchText)
            guard let url = URL(string:
                                    "https://api.pokemontcg.io/v2/cards/?q=name:\(searchText)&pageSize=50&page=\(page)")
                else { return }
            do {
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



#Preview {
    SearchCardView()
}
