import SwiftUI

struct URLImage: View {
    
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 130)
                .background(Color.gray)
        }
    else {
        Image("video")
            .resizable()
            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
            .frame(width: 130)
            .background(Color.gray)
    }
    }

    
    private func fetchData() {
        guard let url = URL(string : urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, _, _ in
            self.data = data
        }
        
        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.Sets, id: \.self) {
                    set in HStack {
                        URLImage(urlString: set)
                        
                        Text(set.name).padding()
                    }
                }
            }.navigationTitle("Cards").padding()
                .onAppear {
                    viewModel.fetch()
                }
        }
    }
}

#Preview {
    ContentView()
}
