import SwiftUI


struct SearchCardView: View {
    @State private var suggestions: [Pokemon] = []
    @State private var searchText = "";
    @State private var searchResults: [Card] = [];
    @State private var filteredSuggestions: [Pokemon] = []
    
    let layout = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    
    var body: some View {
        NavigationStack {
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
            }.navigationTitle("Cards").searchable(text: $searchText).onChange(of: searchText) {
                search()
            }.searchSuggestions{
                ForEach(filteredSuggestions, id: \.name) { suggestion in
                    Text(suggestion.name)
                        .searchCompletion(suggestion.name)
                }
            }
        }.onAppear(){
            getPokemon()
        }
    }
    
    private func getPokemon() {
        Task {
            print("tryting")
            guard let url = URL(string:
                                    "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0")
            else { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
                suggestions = pokemonResponse.results;
                print(suggestions)
            } catch {
                print(error)
            }
        }
    }

    private func search() {
        Task {
            guard let url = URL(string:
                                    "https://api.pokemontcg.io/v2/cards/?q=name:\(searchText)")
                else { return }
                       let (data, _) = try await URLSession.shared.data(from: url)
            let searchResultsResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                searchResults = searchResultsResponse.data
            filteredSuggestions = suggestions.filter {  $0.name.lowercased().contains(searchText.lowercased()) }
            }
        }
}



#Preview {
    SearchCardView()
}
