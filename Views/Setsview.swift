import SwiftUI

struct SetsView : View {
    @StateObject var viewModel = ViewModel<SetResponse>(uri: "https://api.pokemontcg.io/v2/sets", saveHandler: Cache.save, cachedData: Cache.getSets())
    @State private var searchText = "";

    var searchResults: [Set] {
        if searchText.isEmpty {
            return sortSets(sets: viewModel.data)
        } else {
            return sortSets(sets: viewModel.data.filter { $0.name.contains(searchText)})
        }
    }
    
    func sortSets(sets: [Set]) -> [Set]  {
        var newSets = sets
        if sort == 0 { return sets}
        newSets.sort {
            if sort == 1 {
                return  $0.name < $1.name
            }
            if sort == 2 {
                return  $0.name > $1.name
            }
            if sort == 3 {
                return $0.releaseDate < $1.releaseDate
            } else {
                return $0.releaseDate > $1.releaseDate
            }
        }
        return newSets
    }

    @State var sort: Int = 0
    private var sortOptions: [String] = ["None", "Name (Ascending)", "Name (Descending)", "Release Date (Ascending)", "Delease Date (Descending)"]
    

    var body:  some View {
        NavigationStack {
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
            List {
                ForEach(searchResults, id: \.self) {
                    set in
                    NavigationLink(destination: SetView(set: set)) {
                        HStack {
                            if let image = set.images["logo"] {
                                CacheAsyncImage(url: URL(string : image)!) {
                                    phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable().scaledToFit()
                                    case .empty:
                                        ProgressView()
                                    case .failure(_):
                                        ProgressView()
                                    @unknown default:
                                        fatalError()
                                    }
                                }                         }
                            Text(set.name).font(.custom("VT323", size: 24)).padding()
                        }
                    }    
                }
            }.scrollContentBackground(.hidden)
            .background(.white.opacity(0))
            .navigationTitle("")
            .searchable(text: $searchText)
                .onAppear {
                    viewModel.fetchMore(page: 1)
                }
        }
    }
}

#Preview {
    ContentView()
}
