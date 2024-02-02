//
//  FilterTags.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 3/1/24.
//

import SwiftUI

struct FilterTags: View {
    @Binding var selectedTag: String

    var body: some View {
        HStack {
            ForEach(["Todos", "Populares"], id: \.self) { tag in
                Text(tag)
                    .padding([.leading, .trailing], 24)
                    .padding([.top, .bottom], 4)
                    .bold()
                    .background(self.selectedTag == tag ? Color(red: 255/255, green: 40/255, blue: 84/255) : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .onTapGesture {
                        self.selectedTag = tag
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

