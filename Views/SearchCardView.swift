import SwiftUI

struct SearchCardView: View {
    @State private var searchText = "";
    @State private var searchResults: [Card] = [];
    
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
            }
        }
    }
    
    private func search() {
        Task {
            guard let url = URL(string:
                                    "https://api.pokemontcg.io/v2/cards/?q=name:\(searchText.lowercased())")
                else { return }
                       let (data, _) = try await URLSession.shared.data(from: url)
            var searchResultsResponse = try JSONDecoder().decode(CardResponse.self, from: data)
            searchResults = searchResultsResponse.data
            }
        }
    
}
