//
//  URLRequest.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import Foundation

extension URLRequest {
    static func get(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func getWithAuthentication(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        return request
    }
    
    static func post<JSON>(url: URL, data: JSON, method: String = "POST") -> URLRequest where JSON: Codable {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = method
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY", forHTTPHeaderField: "App-Token")
  
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            print("Error encoding data: \(error)")
        }
        
        return request
    }
    
    static func postWithAuthorization<JSON>(url: URL, data: JSON, method: String = "POST", bearerToken: String) -> URLRequest where JSON: Codable {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = method
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY", forHTTPHeaderField: "App-Token")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            print("Error encoding data: \(error)")
        }
        
        return request
    }
    
    static func postLogin<JSON>(url: URL, data: JSON, method: String = "POST") -> URLRequest where JSON: Codable {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = method
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY", forHTTPHeaderField: "App-Token")
        
        if let credentials = data as? Credentials {
            let loginString = "\(credentials.email):\(credentials.password)"
            if let loginData = loginString.data(using: .utf8) {
                let base64LoginString = loginData.base64EncodedString()
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            }
        }
        
        request.httpBody = try? JSONEncoder().encode(data)
        return request
    }
}
