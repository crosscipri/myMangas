//
//  BiometricPopupView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 26/12/23.
//

import SwiftUI

struct BiometricPopupView: View {
    var authentication: Authentication
    var onCancel: () -> Void
    var onAuthenticate: () -> Void

    var body: some View {
        VStack {
            Image(systemName: authentication.biometricType() == .face ? "faceid": "touchid")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .padding(.top)
            Text(authentication.biometricType() == .face ? "Usa Face ID para iniciar sesión" : "Usa Touch ID para iniciar sesión")
                .font(.headline)
                .padding()
            Button("Continuar", action: onAuthenticate)
                .padding(8)
                .buttonStyle(.borderedProminent)
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
            Text("Iniciar sesión manualmente")
                .underline()
                .foregroundStyle(Color.blue)
                .padding()
                .onTapGesture {
                    onCancel()
                }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
       
    }
}

#Preview {
    BiometricPopupView(authentication: Authentication(), onCancel: {
     
    }, onAuthenticate: {
        // Aquí iría tu código para autenticar con Face ID o Touch ID
    })
}
