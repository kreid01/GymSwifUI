import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel<SetResponse>(uri: "https://api.pokemontcg.io/v2/sets")
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.data, id: \.self) {
                    $set in
                    NavigationLink(destination: SetView(set: set)) {
                        HStack {
                            if let image = set.images["logo"] {
                                URLImage(width: 100, urlString: image)
                            }
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
