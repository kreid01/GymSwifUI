import SwiftUI

struct ContentView: View {
    
    var body: some View {
            TabView{
                SetsView()
                             .tabItem {
                                 Label("Sets", systemImage: "house")
                             }
                SearchCardView()
                             .tabItem {
                                 Label("Search", systemImage: "magnifyingglass")
                             }
                CollectionView()
                             .tabItem {
                                 Label("Collection", systemImage: "list.dash")
                             }
                WishlistView()
                             .tabItem {
                                 Label("Wishlist", systemImage: "list.star")
                             }
            }
        }
}


#Preview {
    ContentView()
}

