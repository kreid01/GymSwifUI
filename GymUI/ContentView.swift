import SwiftUI



struct SetView : View {
    let selectedSet: Set
    @StateObject var setViewModel = ViewModel<CardResponse>(uri:
                                                                "https://api.pokemontcg.io/v2/cards")
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach($setViewModel.data, id: \.self) {
                    $card in
                    HStack {
                        if let image = card.images["large"] {
                            URLImage(urlString: image)
                        }
                        Text(card.name).padding()
                    }
                }
            }
        }.navigationTitle(selectedSet.name).padding(.horizontal)
                    .onAppear {
                        setViewModel.fetch()
                    
        }
    }
}

struct Card: Hashable,  Codable {
    let  id: String
    let name : String
    let hp: String
    let types: [String]
    let images : [String: String]
}

struct TCGPlayer : Codable{
    let url : String
    let prices: String
}

struct PokemonImages: Codable {
    let small : String
    let large : String
}

struct Attack: Codable {
    let name : String;
    let cost : [String]
    let damage : String
    let convertedEnergyCost: Int;
    let text: String

}

struct ContentView: View {
    @StateObject var viewModel = ViewModel<SetResponse>(uri: "https://api.pokemontcg.io/v2/sets")
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.data, id: \.self) {
                    $set in
                    NavigationLink(destination: SetView(selectedSet: set)) {
                        HStack {
                            if let image = set.images["logo"] {
                                URLImage(urlString: image)
                            }
                            Text(set.name).padding()
                        }
                    }
                }
            }.navigationTitle("Cards").padding(.horizontal)
                .onAppear {
                    viewModel.fetch()
                }
        }
    }
}

#Preview {
    ContentView()
}
