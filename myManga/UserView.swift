//
//  UserView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 26/12/23.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var authentication: Authentication
    var userEmail = UserDefaults.standard.string(forKey: "email")
    
    var body: some View {
        VStack {
                HStack {
                    Image(systemName: "person.circle")
                        .font(.system(size: 40))
                    VStack(alignment: .leading) {
                        let email = userEmail ?? "user"
                        let username = email.split(separator: "@").first ?? ""
                        Text(String(username))
                            .textCase(.uppercase)
                        Text(userEmail ?? "user@emial.com")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            Button(action: {
                authentication.logout()
                  }) {
                      Text("Cerrar sesión")
                          .foregroundColor(.white)
                          .padding()
                          .frame(maxWidth: .infinity)
                          .background(Color.red)
                          .cornerRadius(10)
                  }
       
        }
        .padding()
     
    }
}

#Preview {
    UserView()
}
