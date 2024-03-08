// CustomAsyncImage.swift

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
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
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
