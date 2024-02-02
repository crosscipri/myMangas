//
//  ContentView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 19/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
            MangasView()
                .tabItem {
                    Label("Mis Mangas", systemImage: "books.vertical")
                }
            UserView()
                .tabItem {
                    Label("Yo", systemImage: "person")
                }
        }
    }
    
}

#Preview {
    ContentView()
}
