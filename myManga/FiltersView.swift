//
//  FiltersView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 5/1/24.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = FiltersVM()
    @StateObject var vmMangas = MangasVM()
    @Binding var searchFilters: CustomSearch?

    @State private var selectedAuthor: String = ""
    @State private var selectedDemographic: String = ""
    @State private var selectedGenre: String = ""
    @State private var selectedTheme: String = ""
    @State private var authorFirstName: String = ""
    @State private var authorLastName: String = ""
    
    @FocusState var focus: String?

    var body: some View {
        VStack {
                   HStack {
                       Text("Filtros")
                           .font(.largeTitle)
                           .bold()
                    
                       Spacer()
                       Button(action: {
                           self.presentationMode.wrappedValue.dismiss()
                       }) {
                           Image(systemName: "x.circle.fill")
                               .font(.title)
                               .foregroundColor(.gray)
                       }
                   }
            
                   .padding()

            Form {
                Section(header: Text("Autor")) {
                            CommonTestField(label: "Autor", text: $selectedAuthor, canEmpty: true)
                                .textContentType(.name)
                                .autocorrectionDisabled()
                                .keyboardType(.default)
                                .focused($focus, equals: "Autor")
                                .onChange(of: selectedAuthor) { _, selectedAuthor in
                                    if selectedAuthor.isEmpty {
                                        vm.authorsByName = []
                                    } else {
                                        print(selectedAuthor)
                                        Task {
                                            try await Task.sleep(nanoseconds: 5_000_000)
                                            await vm.getAuthorsByName(name: selectedAuthor)
                                        }
                                    }
                                }

                    if !vm.authorsByName.isEmpty {
                        ScrollView {
                            LazyVStack {
                                ForEach(vm.authorsByName, id: \.id) { author in
                                    Button {
                                        selectedAuthor = "\(author.firstName) \(author.lastName)"
                                        authorFirstName = author.firstName
                                        authorLastName = author.lastName
                                        
                                        focus = nil
                                    } label: {
                                        HStack {
                                            Text("\(author.firstName) \(author.lastName)")
                                                .foregroundColor(.primary)
                                            Spacer()
                                        }
                                    }
                                    .padding(8)
                                }
                            }
                        }
                        .frame(height: 300)
                    }
                }
                        
                Section(header: Text("Otros")) {
                    Picker("Demográficas", selection: $selectedDemographic) {
                        Text("").tag("")
                        ForEach(vm.demographics, id: \.self) { demographic in
                            Text(demographic)
                        }
                    }
                    Picker("Géneros", selection: $selectedGenre) {
                        Text("").tag("")
                        ForEach(vm.genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    Picker("Temática", selection: $selectedTheme) {
                        Text("").tag("")
                        ForEach(vm.themes, id: \.self) { theme in
                            Text(theme)
                        }
                    }
                }
                .onAppear {
                    Task {
                        await vm.getDemographics()
                        await vm.getGenres()
                        await vm.getThemes()
                    }
                }
                Button(action: {
                    Task {
                        if authorFirstName.isEmpty && authorLastName.isEmpty {
                               searchFilters = CustomSearch(
                                   searchGenres: [selectedGenre],
                                   searchThemes: [selectedTheme],
                                   searchDemographics: [selectedDemographic],
                                   searchContains: false
                               )
                           } else {
                               searchFilters = CustomSearch(
                                   searchAuthorFirstName: authorFirstName,
                                   searchAuthorLastName: authorLastName,
                                   searchGenres: [selectedGenre],
                                   searchThemes: [selectedTheme],
                                   searchDemographics: [selectedDemographic],
                                   searchContains: false
                               )
                           }
                          self.presentationMode.wrappedValue.dismiss()
                      }
                }) {
                    HStack{
                        Spacer()
                        Text("Buscar")
                        Spacer()
                    }
                }
            }
               
            
               }
        .background(Color(.systemGray6))


    }
}

