//
//  Credentials.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 19/12/23.
//

import Foundation

struct Credentials: Codable {
    var email: String = ""
    var password: String = ""
}

struct Registration: Codable {
    var email: String = ""
    var password: String = ""
    var repeatPassword: String = ""
}

struct Token: Codable {
    let value: String
}
