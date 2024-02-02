//
//  GenreTags.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 4/1/24.
//

import SwiftUI


struct GenreTags: View {
    var genres: [Genre]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genres, id: \.id) { genre in
                    Text(genre.genre)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    GenreTags(genres: [
        Genre(genre: "Action", id: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD"),
        Genre(genre: "Adventure", id: "BE70E289-D414-46A9-8F15-928EAFBC5A32"),
        Genre(genre: "Award Winning", id: "4C13067F-96FF-4F14-A1C0-B33215F24E0B"),
        Genre(genre: "Drama", id: "4312867C-1359-494A-AC46-BADFD2E1D4CD"),
        Genre(genre: "Fantasy", id: "B3E8D4B2-7EE4-49CD-8DB0-9897619B3F62"),
        Genre(genre: "Horror", id: "3B6A9037-3F61-4483-AD8A-E43365C5C953"),
        Genre(genre: "Supernatural", id: "AE80120B-6659-4C0E-AEB2-227EC25EC4AF")
    ])
}
