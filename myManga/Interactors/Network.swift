//
//  Network.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import SwiftUI

protocol DataInteractor {
    
    func login(credentials: Credentials) async throws -> String
    func registration(registration: Registration) async throws -> String
    func getAllMangas(page: Int) async throws -> Mangas
    func getBestMangas(page: Int) async throws -> Mangas
    func searchMangasByFilters(filters: CustomSearch) async throws -> Mangas
    func getAuthors() async throws -> [Author]
    func getAuthorsByName(name: String) async throws -> [Author]
    func getDemographics() async throws -> [String]
    func getGenres() async throws -> [String]
    func getThemes() async throws -> [String]
    func addMangaToCollection(collection: Collection) async throws -> Void
    func getMangaCollection() async throws -> [MangaCollection]
    func deleteMangaCollection(id: Int) async throws -> Void
}



struct Network: DataInteractor {

 

    let cache = URL.cachesDirectory

    static let shared = Network()
    
    

     func loadFromKeychain(key: String) -> String? {
          let query = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: key,
              kSecReturnData as String: kCFBooleanTrue!,
              kSecMatchLimit as String: kSecMatchLimitOne
          ] as CFDictionary

          var dataTypeRef: AnyObject?
          let status = SecItemCopyMatching(query, &dataTypeRef)

          if status == noErr {
              if let data = dataTypeRef as? Data, let string = String(data: data, encoding: .utf8) {
                  return string
              }
          }

          return nil
      }
    
    func getJSON<JSON>(request: URLRequest, type: JSON.Type) async throws -> JSON where JSON: Codable {
        let (data, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode == 200 || response.statusCode == 201 {
            do {
                print("Data", data)
                return try JSONDecoder().decode(type, from: data)
            } catch {
                print("Error1", error)
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    func getStringResponse(request: URLRequest) async throws -> String {
        let (data, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode == 200 || response.statusCode == 201 {
            do {
                return String(data: data, encoding: .utf8) ?? ""
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    func getVoidResponse(request: URLRequest) async throws -> Void {
        let (_, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode != 200  || response.statusCode == 201 {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    func getArrayResponse<T: Decodable>(request: URLRequest) async throws -> [T] {
        let (data, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode == 200 || response.statusCode == 201 {
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([T].self, from: data)
                return array
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    func postJSON(request: URLRequest, status: Int = 200) async throws {
        let (_, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode != status {
            throw NetworkError.status(response.statusCode)
        }
    }

    func login(credentials: Credentials) async throws -> String {
        let request = URLRequest.postLogin(url: .login, data: credentials)
        let token: String = try await getStringResponse(request: request)

        return token
    }
    
    func registration(registration: Registration) async throws -> String {
        let credentials = Credentials(email: registration.email, password: registration.password)
        let request = URLRequest.post(url: .createUser, data: credentials)
        let response = try await getStringResponse(request: request)
        
        return response
    }
    
    func getAllMangas(page: Int) async throws -> Mangas {
        var request = URLRequest.get(url: .mangas)
        request.url = URL(string: request.url?.absoluteString.appending("?page=\(page)&per=30") ?? "")
        return try await getJSON(request: request, type: Mangas.self)
    }

    func getBestMangas(page: Int) async throws -> Mangas {
        var request = URLRequest.get(url: .bestMangas)
        request.url = URL(string: request.url?.absoluteString.appending("?page=\(page)&per=30") ?? "")
        return try await getJSON(request: request, type: Mangas.self)
    }
    
    func getAuthorsByName(name: String) async throws -> [Author]  {
        var request = URLRequest.get(url: .authorsByName)
        request.url = URL(string: request.url?.absoluteString.appending("/\(name.lowercased())") ?? "")
        return try await getArrayResponse(request: request)
    }
    
    func searchMangasByFilters(filters: CustomSearch) async throws -> Mangas {
        let request = URLRequest.post(url: .mangasByFilter, data: filters)
        return try await getJSON(request: request, type: Mangas.self)
    }
    
    func getMangaById(filters: CustomSearch) async throws -> Mangas {
        let request = URLRequest.post(url: .mangasByFilter, data: filters)
        return try await getJSON(request: request, type: Mangas.self)
    }
    
    func getAuthors() async throws -> [Author] {
        let request = URLRequest.get(url: .authors)
        return try await getArrayResponse(request: request)
    }
    
    func getDemographics() async throws -> [String] {
        let request = URLRequest.get(url: .demographics)
        return try await getArrayResponse(request: request)
    }
    
    func getGenres() async throws -> [String] {
        let request = URLRequest.get(url: .genres)
        return try await getArrayResponse(request: request)
    }
    
    func getThemes() async throws -> [String] {
        let request = URLRequest.get(url: .themes)
        return try await getArrayResponse(request: request)
    }
    
    func addMangaToCollection(collection: Collection) async throws -> Void {
        let credentialsData = loadFromKeychain(key: "token")
        
        guard let bearerToken = credentialsData else {
            throw NetworkError.authenticationRequired
        }
        
        let request = URLRequest.postWithAuthorization(url: .mangaCollection, data: collection, bearerToken: bearerToken)
        return try await getVoidResponse(request: request)
    }
    
    func getMangaCollection() async throws -> [MangaCollection] {
        let credentialsData = loadFromKeychain(key: "token")
        
        guard let bearerToken = credentialsData else {
            throw NetworkError.authenticationRequired
        }
        let request = URLRequest.getWithAuthentication(url: .mangaCollection, bearerToken:  bearerToken)
        return try await getArrayResponse(request: request)
    }
    
    func deleteMangaCollection(id: Int) async throws -> Void {
        let credentialsData = loadFromKeychain(key: "token")
        
        guard let bearerToken = credentialsData else {
            throw NetworkError.authenticationRequired
        }
        
        var request = URLRequest.getWithAuthentication(url: .mangaCollection, bearerToken:  bearerToken)
        request.url = URL(string: request.url?.absoluteString.appending("/\(id)") ?? "")
        
        return try await getVoidResponse(request: request)
    }
    
}
