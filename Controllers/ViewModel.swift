import SwiftUI

class ViewModel<T: DataContainer>: ObservableObject where T: Decodable{
    @Published var data: [T.DataType] = []
    var uri: String
    init(uri: String) {
        self.uri = uri;
    }
    
    func fetch() {
        guard let url = URL(string:uri) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("X-Api-Key", forHTTPHeaderField: "ba775f42-3e3c-4fe2-84ee-def10fa44232")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                 guard let data = data, error == nil else {
                     return
                 }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                               DispatchQueue.main.async {
                                   self?.data = decodedData.data
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }

}


