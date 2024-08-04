import SwiftUI

class CardViewModel: ObservableObject{
    @Published var selectedCard: SelectedCard?
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
                let decodedData = try JSONDecoder().decode(GymUI.SelectedCardResponse.self, from: data)
                               DispatchQueue.main.async {
                                   self?.selectedCard = decodedData.data
                                   
                                   print(decodedData.data)
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }

}
