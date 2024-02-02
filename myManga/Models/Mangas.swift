//
//  Mangas.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 27/12/23.
//

import Foundation

struct Mangas: Codable {
    let metadata: Metadata
    let items: [Item]
}

struct FiltredMangas: Codable {
    let items: [Item]
}

struct Item: Codable, Equatable, Hashable {
    let authors: [Author]
    let volumes: Int?
    let endDate: String?
    let title: String
    let genres: [Genre]
    let url: String
    let titleEnglish: String?
    let chapters: Int?
    let score: Double
    let startDate: String?
    let sypnosis: String?
    let background: String?
    let status: String
    let titleJapanese: String
    let themes: [Theme]
    let id: Int
    let demographics: [DemographicElement]
    let mainPicture: String?
    
       
       var mainPictureURL: URL? {
           if let mainPicture = mainPicture {
               return URL(string: mainPicture)
           }
           return nil
       }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
       
}

struct Metadata: Codable, Equatable {
    let total, per, page: Int
}

struct Author: Codable, Equatable, Hashable {
    let id: String
    let role: String
    let lastName: String
    let firstName: String

}

struct DemographicElement: Codable, Equatable {
    let id: UUID
    let demographic: String
}

struct Genre: Codable, Equatable {
    let genre, id: String
}

struct Theme: Codable, Equatable {
    let theme, id: String
}


struct CustomSearch: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchThemes: [String]?
    var searchDemographics: [String]?
    var searchContains: Bool
}

struct Collection: Codable {
    var manga: Int
    var completeCollection: Bool
    var volumesOwned: [Int]
    var readingVolume: Int
}

struct User: Codable, Equatable, Hashable {
    var id: String
}

struct MangaCollection: Codable, Equatable, Hashable {
    var user: User
    var volumesOwned: [Int]
    var readingVolume: Int
    var id: String
    var completeCollection: Bool
    var manga: Item
}

