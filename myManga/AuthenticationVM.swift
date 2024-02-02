//
//  Authentication.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import SwiftUI
import LocalAuthentication
import Security

final class Authentication: ObservableObject {
    @Published var isValidate = false
    @Published var isAuthorized = false
    
    enum BiometricType {
        case none
        case face
        case touch
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        case deniedAccess
        case noFaceIdEnrolled
        case noFingerPrintEnrolled
        case biometricError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "Credenciales incorrectas"
            case .deniedAccess:
                return "Acceso denegado"
            case .noFaceIdEnrolled:
                return "No estas registrado con Face Id"
            case .noFingerPrintEnrolled:
                return "No estas registrado con finger"
            case .biometricError:
                return "No puedes acceder con biometria"
            case .credentialsNotSaved:
                return "Credenciales sin guardar"
            }
        }
    }
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidate = success
        }
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let  _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        case .opticID:
            return .none
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {
          var credentials: Credentials? = nil
        if let credentialsData = loadFromKeychain(key: "userCredentials") {
            credentials = try? JSONDecoder().decode(Credentials.self, from: credentialsData)
        }
   
        guard let credentials = credentials else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else {
                    completion(.failure(.noFingerPrintEnrolled))
                }
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to acces credentials.") { 
                    success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
    
    func areCredentialsSaved() -> Bool {
        if let credentialsData = loadFromKeychain(key: "userCredentials") {
            let credentials = try? JSONDecoder().decode(Credentials.self, from: credentialsData)
            return credentials != nil
        } else {
            return false
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
    
    
    func logout() {
        let status = deleteFromKeychain(key: "userCredentials")
        if status == errSecSuccess {
            print("Credentials deleted successfully!")
            self.isValidate = false
            self.isAuthorized = false
        } else {
            print("Failed to delete credentials!")
        }
    }
    
    func deleteFromKeychain(key: String) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ] as [String : Any]

        return SecItemDelete(query as CFDictionary)
    }
}
