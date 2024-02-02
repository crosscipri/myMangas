//
//  StarRating.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 4/1/24.
//

import SwiftUI

struct StarRating: View {
    var rating: Double

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ForEach(0..<5) { index in
                if Double(index) < rating / 2.0 {
                    if Double(index) + 0.5 < rating / 2.0 {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.yellow)
                            .padding(.horizontal, -3)
                    } else {
                        Image(systemName: "star.leadinghalf.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.yellow)
                            .padding(.horizontal, -3)
                    }
                } else {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                        .padding(.horizontal, -3)
                }
            }
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .bold()
        }
    }
}
#Preview {
    StarRating(rating: 5)
}
