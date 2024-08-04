import SwiftUI

struct SetsView : View {
    @StateObject var viewModel = ViewModel<SetResponse>(uri: "https://api.pokemontcg.io/v2/sets")
    @State private var searchText = "";
    
    var searchResults: [Set] {
        if searchText.isEmpty {
            return viewModel.data
        } else {
            return viewModel.data.filter { $0.name.contains(searchText)}
        }
    }

    var body:  some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) {
                    set in
                    NavigationLink(destination: SetView(set: set)) {
                        HStack {
                            if let image = set.images["logo"] {
                                URLImage(width: 100, urlString: image)
                            }
                            Text(set.name).padding()
                        }
                    }
                    
                }
            }.navigationTitle("Sets").searchable(text: $searchText)
                .onAppear {
                    viewModel.fetch()
                }
        }
    }
}
