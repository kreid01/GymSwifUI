import SwiftUI

class CardViewModel: ObservableObject{
    @Published var selectedCard: Card?
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
                     print("failed")
                     return
                 }
            do {
                print(data)
                let decodedData = try JSONDecoder().decode(GymUI.SelectedCardResponse.self, from: data)
                               DispatchQueue.main.async {
                                   self?.selectedCard = decodedData.data
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

