//
//  LoginView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 19/12/23.
//

import SwiftUI
import Security

struct LoginView: View {
    @StateObject var loginVM = LoginVM()
    @EnvironmentObject var authentication: Authentication
    @State private var showNextView = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var biometyError = false
    @State private var showBiometricPopup = false


    @FocusState var focus: String?
    var body: some View {
        ZStack {
            Color(red: 242.0 / 255.0, green: 236.0 / 255.0, blue: 228.0 / 255.0)
                .ignoresSafeArea()
            VStack {
                Image(.loginIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                Text("Inicio de sesión")
                    .font(.largeTitle)
                    .scaledToFill()
                    .bold()
                    .padding(.top)
                CommonTestField(label: "Email", text: $loginVM.credentials.email, canEmpty: false, validator: Validators
                    .shared
                    .validEmail)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .focused($focus, equals: "Email")
                .frame(maxWidth: 500)
                .padding(.top)
                .padding(.bottom)
                CommonSecureField(label: "Contraseña", text: $loginVM.credentials.password, validator: Validators
                    .shared
                    .greaterThan4)
                .textContentType(.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($focus, equals: "Contraseña")
                .frame(maxWidth: 500)
                .padding(.bottom)
                Spacer()
                Button(action: {
                    focus = nil
                    isLoading = true
                    Task {
                        do {
                            let success = try await loginVM.login()
                                           await MainActor.run {
                                               authentication.updateValidation(success: success)
                                           }
                                           if !success {
                                               showAlert = true
                                           }
                        }
                        isLoading = false
                    }
                } ){
                                Text("Iniciar sesión")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(minWidth: 250)
                                    .background(Color(red: 255.0 / 255.0, green: 40.0 / 255.0, blue: 84.0 / 255.0))
                                    .cornerRadius(20)
                            }
                
                .opacity(loginVM.loginDisabled ? 0.5 : 1)
                .disabled(loginVM.loginDisabled)
                            Button(action: {
                                showNextView = true }) {
                                Text("Registrarse")
                                    .foregroundStyle(Color(red: 255.0 / 255.0, green: 40.0 / 255.0, blue: 84.0 / 255.0))
                                    .padding()
                                    .frame(minWidth: 250)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 255.0 / 255.0, green: 40.0 / 255.0, blue: 84.0 / 255.0), lineWidth: 1)
                                    )
                            }
                            .sheet(isPresented: $showNextView, content: AuthenticationView.init)
            }
            .alert(isPresented: $showAlert) {
                if biometyError == true {
                    return Alert(title: Text("Error"), message: Text("Credenciales no guardadas"), primaryButton: .default(Text("OK"), action: {
                        print("")
                    }), secondaryButton: .cancel())

                } else {
                    return Alert(title: Text("Error"), message: Text("El inicio de sesion ha fallado"), dismissButton: .default(Text("OK")))

                }

                      }
            .padding()
       
    
            if isLoading {
                    ProgressView()
                          .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 255.0 / 255.0, green: 40.0 / 255.0, blue: 84.0 / 255.0)))
                          .frame(maxWidth: .infinity, maxHeight: .infinity)
                          .background(Color.black.opacity(0.5))
                          .ignoresSafeArea()
                       }
            if showBiometricPopup {
                          BiometricPopupView(authentication: authentication, onCancel: {
                              showBiometricPopup = false
                          }, onAuthenticate: {
                              authentication.requestBiometricUnlock { (result: Result<Credentials, Authentication.AuthenticationError>) in
                                  switch result {
                                  case .success(let credentils):
                                      loginVM.credentials = credentils
                                      isLoading = true
                                      Task {
                                          do {
                                              let success = try await loginVM.login()
                                                             await MainActor.run {
                                                                 authentication.updateValidation(success: success)
                                                             }
                                                             if !success {
                                                                 showAlert = true
                                                             }
                                          }
                                          isLoading = false
                                      }
                                  case .failure(_):
                                      biometyError = true
                                      showAlert = true
                                  }
                                  
                              }
                          })
                          .transition(.move(edge: .bottom))
                      }
        }
        .onAppear {
            if authentication.biometricType() != .none && authentication.areCredentialsSaved() {
                withAnimation {
                               showBiometricPopup = true
                           }
                }
             }
    }
}

#Preview {
    LoginView()
        .environmentObject(Authentication())
}
