//
//  MangaCell.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 27/1/24.
//

import SwiftUI

struct MangaCell: View {
    let mangaCollection: MangaCollection
    
    var body: some View {
        HStack{
            if let urlStringOptional = mangaCollection.manga.mainPicture,
               let url = URL(string: urlStringOptional.trimmingCharacters(in: .init(charactersIn: "\""))) {
                AsyncImage(url: url)
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .gray, radius: 1, x: 0, y: 1)
            }
            VStack(alignment: .leading){
                Text(mangaCollection.manga.title)
                    .font(.title)
                    .bold()
                    .lineLimit(1)
                if !mangaCollection.manga.demographics.isEmpty {
                    Text("\(mangaCollection.manga.demographics.map { $0.demographic }.joined(separator: ", "))")
                        .font(.subheadline)
                        .padding(.bottom)
                }
                HStack {
                    Text("Volumen \(mangaCollection.readingVolume)")
                        .padding(.horizontal, 10)
                        .font(.subheadline)
                        .foregroundColor(Color.orange)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.orange, lineWidth: 2))
                        .bold()
                    CollectionStatus(completeCollection: mangaCollection.completeCollection)
                }
                
            }
            Spacer()

        }

    }
}

#Preview {
    MangaCell(mangaCollection: .collectionTest)
}
