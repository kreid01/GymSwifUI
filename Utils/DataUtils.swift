import SwiftUI

class DataUtils {
    func GetData<T: Decodable>(uri: String, completion: @escaping (T?) -> Void) {
       guard let url = URL(string: uri) else {
           completion(nil)
           return
       }
       
       let task = URLSession.shared.dataTask(with: url) { data, _, error in
           guard let data = data, error == nil else {
               completion(nil)
               return
           }
           
           do {
               let decodedData = try JSONDecoder().decode(T.self, from: data)
               DispatchQueue.main.async {
                   completion(decodedData)
               }
           } catch {
               completion(nil)
           }
       }
       
       task.resume()
   }
}

