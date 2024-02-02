//
//  LoginViewModel.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import Foundation

final class LoginVM: ObservableObject {
    let network: DataInteractor
    @Published var credentials = Credentials()
    @Published var log = ""
    @Published var msg = ""
    
    init(network: DataInteractor = Network()) {
        self.network = network
    }
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    func login() async throws -> Bool {
        do {
            let login = try await network.login(credentials: credentials)
            await MainActor.run {
                log = login
                UserDefaults.standard.set(credentials.email, forKey: "email")               
                saveStringToKeychain(key: "token", string: login)
                let credentialsData = try? JSONEncoder().encode(credentials)
                if let credentialsData = credentialsData {
                    let status = saveToKeychain(key: "userCredentials", data: credentialsData)
                    if status == errSecSuccess {
                        print("Credentials saved successfully!")
                    } else {
                        print("Failed to save credentials!")
                    }
                }
            }
            return true
        } catch {
            await MainActor.run {
                msg = "\(error)"
            }
            return false
        }
    }
    
    func saveToKeychain(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func saveStringToKeychain(key: String, string: String) -> OSStatus {
          if let data = string.data(using: .utf8) {
              return saveToKeychain(key: key, data: data)
          } else {
              return errSecInvalidData
          }
      }

    func loadFromKeychain(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

}

