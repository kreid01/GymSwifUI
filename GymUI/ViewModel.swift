//
//  ViewModel.swift
//  GymUI
//
//  Created by Kieran Reid on 02/08/2024.
//

import SwiftUI

protocol DataContainer: Decodable {
    associatedtype DataType: Decodable & Hashable
    var data: [DataType] { get set }
}

struct SetResponse: DataContainer ,Hashable  {
    var data: [Set]
}

struct CardResponse: DataContainer, Hashable {
    var data: [Card]
}

struct Set: Hashable, Codable{
    let id: String
    let name: String;
    let series: String;
    let printedTotal : Int;
    let releaseDate: String
    let images: [String: String]
}

struct SetImage: Codable {
    let symbol: String;
    let logo: String
}

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


struct SetViewModel {
    
}
