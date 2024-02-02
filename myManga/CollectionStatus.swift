//
//  CollectionStatus.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 28/1/24.
//

import SwiftUI

struct CollectionStatus: View {
    var completeCollection: Bool

    var body: some View {
        Text(completeCollection ? "Completado" : "En progreso")
            .padding(.horizontal, 10)
            .font(.subheadline)
            .foregroundColor(completeCollection ? Color.blue : Color.green)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(completeCollection ? Color.blue : Color.green, lineWidth: 2))
            .bold()
    }
}

#Preview {
    CollectionStatus(completeCollection: true)
}
