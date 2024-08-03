//
//  URLImage.swift
//  GymUI
//
//  Created by Kieran Reid on 03/08/2024.
//
import SwiftUI

struct URLImage: View {
    
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
        }
        else {
            Image("video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .onAppear {
                    fetchData()
                }
        }
    }

    private func fetchData() {
        guard let url = URL(string : urlString) else {
            return
        }
        print(url)

        let task = URLSession.shared.dataTask(with: url) {
            data, _, _ in
            self.data = data
        }
        
        task.resume()
    }
}
