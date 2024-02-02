//
//  RegistrationAlert.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 21/12/23.
//

import SwiftUI

enum AlertType: Identifiable {
    case passwordMismatch
    case registrationError
    case registrationSuccess
    
    var id: Int {
            switch self {
            case .passwordMismatch:
                return 1
            case .registrationError:
                return 2
            case .registrationSuccess:
                return 3
            }
        }
}


struct RegistrationAlert: View {
    @Binding var alertType: AlertType?
       
       var body: some View {
           EmptyView()
               .alert(item: $alertType) { type in
                   switch type {
                   case .passwordMismatch:
                       return Alert(title: Text("Error"), message: Text("Passwords do not match."), dismissButton: .default(Text("OK")))
                   case .registrationError:
                       return Alert(title: Text("Error"), message: Text("El registro no se ha completado con éxito"), dismissButton: .default(Text("OK")))
                   case .registrationSuccess:
                       return Alert(title: Text("Éxito"), message: Text("El registro se ha completado con éxito"), dismissButton: .default(Text("OK")))
                   }
               }
       }
}

#Preview {
    RegistrationAlert(alertType: .constant(.passwordMismatch))
}
