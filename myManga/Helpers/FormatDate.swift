//
//  FormatDate.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 4/1/24.
//

import Foundation


func formatDate(_ dateString: String?) -> String {
    guard let dateString = dateString else { return "N/A" }

    let isoFormatter = ISO8601DateFormatter()
    let date = isoFormatter.date(from: dateString)

    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"

    return date != nil ? formatter.string(from: date!) : "N/A"
}
