//
//  ViewModel.swift
//  GymUI
//
//  Created by Kieran Reid on 02/08/2024.
//

import SwiftUI

struct Set: Hashable, Codable{
    let id: String
    let name: String;
    let series: String;
    let printedTotal : Int;
    let releaseDate: String
}

struct SetReturn: Codable {
let data: [Set]
}

struct SetImage {
    let symbol: String;
    let logo: String
}

class ViewModel: ObservableObject {
    @Published var Sets: [Set] = []
    
    func fetch() {
        guard let url = URL(string:
           "https://api.pokemontcg.io/v2/sets") else {
            return
        }
        
                            
        let task = URLSession.shared.dataTask(with: url) { [weak self] data,
            _, error in
            
            guard let data = data, error == nil else {
                return
            }

            do {
                let sets = try JSONDecoder().decode(SetReturn.self,
                                                    from: data)
                print(sets)
                DispatchQueue.main.async {
                    self?.Sets = sets.data
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
