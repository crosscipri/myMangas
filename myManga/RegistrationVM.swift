//
//  RegistrationVM.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 21/12/23.
//

import Foundation

final class RegistrationVM: ObservableObject {
    let network: DataInteractor
    @Published var registration = Registration()
    @Published var msg = ""
    @Published var result = ""
    init(network: DataInteractor = Network()) {
        self.network = network
    }
    
    
    func registration() async throws -> Bool {
        do {
            let res = try await network.registration(registration: registration)
            await MainActor.run {
                result = res
                
            }
            return true
        } catch {
            await MainActor.run {
                msg = "\(error)"
            }
            return false
        }
    }
}
