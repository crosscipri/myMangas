//
//  AuthenticationView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 19/12/23.
//

import SwiftUI

struct AuthenticationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var registrationVM = RegistrationVM()
    @State private var showingAlert = false
    @State private var showingSuccessAlert = false
    @State private var isLoading = false
    @State private var alertType: AlertType?

    @FocusState var focus: String?

      var body: some View {
          VStack {
           
              HStack {
                  Spacer()
                  Button(action: {
                      self.presentationMode.wrappedValue.dismiss()
                  }) {
                      Image(systemName: "x.circle.fill")
                          .font(.title)
                          .foregroundColor(.gray)
                  }
              }.padding()
              Text("Registrate")
                  .font(.largeTitle)
                  .scaledToFill()
                  .bold()
              Spacer()
              
              Section {
                  CommonTestField(label: "Email", text: $registrationVM.registration.email, canEmpty: false, validator: Validators
                      .shared
                      .validEmail)
                  .textContentType(.emailAddress)
                  .autocorrectionDisabled()
                  .textInputAutocapitalization(.never)
                  .keyboardType(.emailAddress)
                  .focused($focus, equals: "Email")
                  .frame(maxWidth: 500)
                  CommonSecureField(label: "Contraseña", text: $registrationVM.registration.password, validator: Validators
                      .shared
                      .greaterThan4)
                  .textContentType(.password)
                  .autocorrectionDisabled()
                  .textInputAutocapitalization(.never)
                  .focused($focus, equals: "Contraseña")
                  .frame(maxWidth: 500)
                  CommonSecureField(label: "Confirmar Contraseña", text: $registrationVM.registration.repeatPassword, validator: Validators
                      .shared
                      .greaterThan4
                     )
                  .textContentType(.password)
                  .autocorrectionDisabled()
                  .textInputAutocapitalization(.never)
                  .focused($focus, equals: "Contraseña")
                  .frame(maxWidth: 500)
              }
              .padding()
              Button {
                          if Validators.shared.passwordsMatch(registrationVM.registration.password, registrationVM.registration.repeatPassword) == true {
                              focus = nil
                              Task {
                                  do {
                                      let success = try await registrationVM.registration()
                                                     if success {
                                                         alertType = .registrationSuccess
                                                     } else {
                                                         alertType = .registrationError
                                                     }
                                  }
                                  isLoading = false
                              }
                          } else {
                              alertType = .passwordMismatch
                          }
                      } label: {
                          Text("Registrate")
                      }
                      .padding(8)
                      .buttonStyle(.borderedProminent)
                      .background(Color.blue)
                      .cornerRadius(10)
                      .foregroundColor(.white)
             

              .padding(.top)
              .buttonStyle(.bordered)
              
           Spacer()
          }
          .alert(item: $alertType) { type in
                   switch type {
                   case .passwordMismatch:
                       return Alert(title: Text("Error"), message: Text("Passwords do not match."), dismissButton: .default(Text("OK")))
                   case .registrationError:
                       return Alert(title: Text("Error"), message: Text("El registro no se ha completado con éxito"), dismissButton: .default(Text("OK")))
                   case .registrationSuccess:
                       return Alert(title: Text("Éxito"), message: Text("El registro se ha completado con éxito"), dismissButton: .default(Text("OK")) {
                           self.presentationMode.wrappedValue.dismiss()
                       })
                   }
               }

   
      }
}

#Preview {
    AuthenticationView()
}
