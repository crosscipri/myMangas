//
//  URL.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import Foundation

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/")!

extension URL {
    static let createUser = api.appending(path: "users")
    static let login = api.appending(path: "users/login")
    static let mangas = api.appending(path: "list/mangas")
    static let bestMangas = api.appending(path: "list/bestMangas")
    static let mangasByFilter = api.appending(path: "search/manga")
    static let authors = api.appending(path: "list/authors")
    static let demographics = api.appending(path: "list/demographics")
    static let genres = api.appending(path: "list/genres")
    static let themes = api.appending(path: "list/themes")
    static let authorsByName = api.appending(path: "search/author")
    static let mangaCollection = api.appending(path: "collection/manga")
}
