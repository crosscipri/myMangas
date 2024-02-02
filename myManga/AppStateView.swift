//
//  AppStateView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 26/12/23.
//

import SwiftUI

struct AppStateView: View {
    @StateObject var authentication = Authentication()
    var body: some View {
        Group {
            if authentication.isValidate {
                ContentView()
                    .environmentObject(authentication)
            } else {
                LoginView()
                    .environmentObject(authentication)
            }
        }
    }
}

#Preview {
    AppStateView()
}
