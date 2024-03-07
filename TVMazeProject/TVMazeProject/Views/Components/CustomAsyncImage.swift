//
//  CustomAsyncImage.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 06/03/24.
//

import SwiftUI

struct CustomAsyncImage: View {
    let urlString: String?
    let placeholder: Image
    
    init(urlString: String?, placeholder: Image = Image(systemName: "photo")) {
        self.urlString = urlString
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let urlString = urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure:
                    placeholder
                default:
                    ProgressView()
                }
            }
        } else {
            placeholder
        }
    }
}


#Preview {
    CustomAsyncImage(urlString: nil)
}
