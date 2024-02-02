//
//  SearcherInput.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 3/1/24.
//

import SwiftUI

struct SearcherInput:  View {
    
    @ObservedObject var vm: MangasVM

    @Binding var text: String
    @Binding var selectedTag: String


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Buscar mangas", text: $text)
                    .onChange(of: text) { _ , newValue in
                        if newValue.isEmpty {
                            Task {
                                vm.mangas.mangas = []
                                vm.currentPage = 1
                                if selectedTag == "Todos" {
                                    await vm.getAllMangas()
                                } else if selectedTag == "Populares" {
                                    await vm.getBestMangas()
                                }
                            }
                        } else {
                            Task {
                                try await Task.sleep(nanoseconds: 5_000_000)
                                let searchFilters = CustomSearch(searchTitle: newValue, searchContains: true)
                                vm.mangas.mangas = []
                                vm.currentPage = 1
                                await vm.searchMangasByFilters(filters: searchFilters)
                            }
                        }
                    }
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .symbolVariant(.fill)
                        .symbolVariant(.circle)
                }
                .buttonStyle(.plain)
                .opacity(text.isEmpty ? 0.0 : 0.5)
            }
            .padding(12)
            .background {
                Color(white: 0.9)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
}

