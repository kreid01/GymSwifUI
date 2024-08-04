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
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
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


