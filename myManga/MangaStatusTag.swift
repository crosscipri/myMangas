//
//  MangaStatusTag.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 4/1/24.
//

import SwiftUI

struct MangaStatusTag: View {
    var status: PublishingStatus

    var body: some View {
        Text(displayText(for: status))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(statusColor(for: status))
            .foregroundColor(.white)
            .bold()
            .cornerRadius(10)
    }

    private func displayText(for status: PublishingStatus) -> String {
        switch status {
        case PublishingStatus.currentlyPublishing:
            return "En Progreso"
        case PublishingStatus.finished:
            return "Terminada"
        }
    }

    private func statusColor(for status: PublishingStatus) -> Color {
        switch status {
        case PublishingStatus.currentlyPublishing:
            return .blue
        case PublishingStatus.finished:
            return .green
        }
    }
}

#Preview {
    MangaStatusTag(status: PublishingStatus.currentlyPublishing)
}
