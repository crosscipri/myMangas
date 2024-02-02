//
//  MangasView.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 26/12/23.
//

import SwiftUI

struct MangasView: View {
    @StateObject var mangasVM = MangasVM()

    @State var mangaPath: [MangaCollection] = []
    
    var body: some View {
        NavigationStack(path: $mangaPath) {
            List {
                ForEach(mangasVM.collection, id: \.id) { mangaCollection in
                    NavigationLink(value: mangaCollection) {
                        MangaCell(mangaCollection: mangaCollection)
                    }
                }
                .onDelete { indexSet in
                      for index in indexSet {
                          let mangaCollection = mangasVM.collection[index]
                          Task {
                              await mangasVM.deleteMangaCollection(id: mangaCollection.manga.id)
                          }
                      }
                      mangasVM.collection.remove(atOffsets: indexSet)
                  }
            }
            .listRowSpacing(10)
            .listStyle(.grouped)
            .navigationTitle("Mis Mangas")
            .navigationDestination(for: MangaCollection.self) { mangaCollection in
                MangaCollectionDetail(mangaCollection: mangaCollection, path: $mangaPath)
            }
            .onAppear {
                Task {
                    await mangasVM.getMangasCollection()
                }
            }
        }
    }
}


#Preview {
    MangasView()
}
