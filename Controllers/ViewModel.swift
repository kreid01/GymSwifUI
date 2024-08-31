import SwiftUI

class ViewModel<T: DataContainer>: ObservableObject where T: Decodable{
    @Published var data: [T.DataType] = []
    var uri: String
    let saveHandler: ([T.DataType]) -> Void?
    var cachedData : [T.DataType] = []
    
    init(uri: String, saveHandler: @escaping ([T.DataType]) -> Void, cachedData: [T.DataType]) {
        self.uri = uri;
        self.saveHandler = saveHandler
        self.cachedData = cachedData;
    }
    
    func fetchMore(page: Int) {
        if cachedData == [] {
            guard let url = URL(string:uri + "&pageSize=50&page=\(page)") else {
                return
            }
            
            var request = URLRequest(url: url)
            print(url)
            request.setValue("X-Api-Key", forHTTPHeaderField: "ba775f42-3e3c-4fe2-84ee-def10fa44232")
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                     guard let data = data, error == nil else {
                         return
                     }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                                   DispatchQueue.main.async {
                                       self?.data.append(contentsOf: decodedData.data)
                                       self?.saveHandler(decodedData.data)
                    }
                }
                catch {
                    print(error)
                }
            }
            
            task.resume()
        } else {
            self.data = cachedData;
        }
        }
}


#Preview {
    SetsView()
}
