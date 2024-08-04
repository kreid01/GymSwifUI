import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: SetsView()) {
                    Text("Sets")
                }
                NavigationLink(destination: SearchCardView()) {
                    Text("Search Cards")
                }
            }
            .navigationTitle("Home")
        }
    }
}


#Preview {
    ContentView()
}

