//
//  MangaCard.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 28/12/23.
//

import SwiftUI

struct MangaCard: View {
    let manga: Item
    var big: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            if let urlStringOptional = manga.mainPicture,
               let url = URL(string: urlStringOptional.trimmingCharacters(in: .init(charactersIn: "\""))) {
                AsyncImage(url: url)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                StarRating(rating: manga.score)
            }
        }
        .frame(height: 200)
    }
}

#Preview {
    MangaCard(manga: .test)
}
