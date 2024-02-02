//
//  MangasGrid.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 27/12/23.
//

import SwiftUI
import SwiftData

struct MangasGrid: View {
    
    @StateObject var vm = MangasVM()
    
    @State var selectedTag: String = "Todos"
    @State var searchText: String = ""
    @State var selected: Item?
    @State var showFilters: Bool = false
    @State private var searchFilters: CustomSearch?
    
    @State private var loaded = false
    
    let items = Array(repeating: GridItem(.flexible(), alignment: .center), count: 3)
    
    var body: some View {
        ZStack {
            mainScroll
                .opacity(selected == nil ? 1.0 : 0.0)
            if selected != nil {
                MangaDetail(selected: $selected)
            }
            if vm.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 255.0 / 255.0, green: 40.0 / 255.0, blue: 84.0 / 255.0)))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
        }
        .animation(.default, value: selected)
    }
    
    var mainScroll: some View {
        NavigationStack {
            HStack {
                SearcherInput(vm: vm, text: $searchText, selectedTag: $selectedTag)
                FilterButton(showFilters: $showFilters)
                    .sheet(isPresented: $showFilters, onDismiss: {
                        if let filters = searchFilters {
                            vm.mangas.mangas = []
                            vm.currentPage = 1
                            Task {
                                await vm.searchMangasByFilters(filters: filters)
                            }
                        }
                    }) {
                        FiltersView(searchFilters: $searchFilters)
                    }          }
            FilterTags(selectedTag: $selectedTag)
                .padding([.top, .bottom])
            ScrollView {
                LazyVGrid(columns: items,  spacing: 30) {
                    ForEach(Array(vm.mangas.mangas.enumerated()), id: \.element.id) { index, manga in
                        if manga != selected {
                            MangaCard(manga: manga)
                                .onTapGesture {
                                    selected = manga
                                }
                                .onAppear {
                                    if index == vm.mangas.mangas.count - 9 && !vm.isLoading {
                                        Task {
                                            if selectedTag == "Todos" {
                                                await vm.getAllMangas()
                                            } else if selectedTag == "Populares" {
                                                await vm.getBestMangas()
                                            }
                                        }
                                    }
                                }
                        } else {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 150, height: 230)
                        }
                    }
                }
            }
            .onChange(of: selectedTag) { _ , newValue in
                vm.mangas.mangas = []
                vm.currentPage = 1
                Task {
                    if newValue == "Todos" {
                        await vm.getAllMangas()
                    } else if newValue == "Populares" {
                        await vm.getBestMangas()
                    }
                }
            }
        
        }.padding()
    }
}

#Preview {
    MangasGrid()
}
