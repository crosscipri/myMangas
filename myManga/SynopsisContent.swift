//
//  SynopsisContent.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 4/1/24.
//

import SwiftUI

struct SynopsisContent: View {
    @State private var isExpanded = false
    var sypnosis: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(sypnosis ?? "No synopsis available.")
                    .font(.body)
                    .lineLimit(isExpanded ? nil : 6)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
                
                Button(action: {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .frame(height: 40)
                            .foregroundStyle(Color.black)
                            .bold()
                        Spacer()
                    }
                }
                .background(Color.white)
            }
        }
    }
}

#Preview {
    SynopsisContent(sypnosis: "Synopsis")
}
