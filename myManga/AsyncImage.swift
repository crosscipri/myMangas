//
//  AsyncImage.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 4/1/24.
//

import SwiftUI

struct AsyncImage: View {
    @StateObject private var imageVM = ImageVM()

    let url: URL

    var body: some View {
        Group {
            if let image = imageVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .onAppear { try?  imageVM.getImage(url: url)}
        .onChange(of: url) {
            try? imageVM.getImage(url: url)
        }
    }
}
