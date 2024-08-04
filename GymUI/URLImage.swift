import SwiftUI

struct URLImage: View {
    let width: CGFloat
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
        }
        else {
            Image("")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .onAppear {
                    fetchData()
                }
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
