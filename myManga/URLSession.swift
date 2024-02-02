//
//  URLSession.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import Foundation

extension URLSession {
    func getData(from url: URL, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: delegate)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noHTTP
            }  
            return (data, response)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.general(error)
        }
    }
    
    func getData(for url: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: url, delegate: delegate)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noHTTP
            }
            print("HTTP Status Code: \(response.statusCode)")
            return (data, response)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.general(error)
        }
    }
}
