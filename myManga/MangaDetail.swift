//
//  MangaDetail.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 3/1/24.
//

import SwiftUI

struct MangaDetail: View {
    @StateObject var vm = MangasVM()
    
    private var manga: Item!
    
    @Binding var selected: Item?
    
    @State private var loaded = false
    @State private var isAddedToCollection = false
    
    
    init(selected: Binding<Item?>) {
        _selected = selected
        if let manga = selected.wrappedValue {
            self.manga = manga
        }
    }
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                LazyVStack {
                    VStack(alignment: .leading, spacing: 16) {
                        if let urlStringOptional = manga.mainPicture,
                           let url = URL(string: urlStringOptional.trimmingCharacters(in: .init(charactersIn: "\""))) {
                            AsyncImage(url: url)
                                .cornerRadius(20)
                                .frame(height: 300)
                                .clipped()
                                .blur(radius: 4)
                                .overlay(alignment: .leading) {
                                    Color.gray.opacity(0.4)
                                    GeometryReader { proxy in
                                        Color.clear
                                            .preference(key: ScrollOffset.self,
                                                        value: proxy.frame(in: .global).minY)
                                    }
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        HStack(alignment: .bottom) {
                                            AsyncImage(url: url)
                                                .scaledToFit()
                                                .frame(height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                                            VStack(alignment: .leading) {
                                                Text(manga.title)
                                                    .font(.largeTitle)
                                                Text("(\(manga.titleJapanese))")
                                                    .font(.title3)
                                                if !manga.demographics.isEmpty {
                                                    Text("\(manga.demographics.map { $0.demographic }.joined(separator: ", "))")
                                                        .font(.subheadline)
                                                }
                                                StarRating(rating: manga.score)
                                                Text("Inicio: \(formatDate(manga.startDate))")
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                if let endDate = manga.endDate {
                                                    Text("Fin: \(formatDate(endDate))")
                                                        .font(.subheadline)
                                                        .fontWeight(.medium)
                                                }
                                                if let status = PublishingStatus(rawValue: manga.status) {
                                                    MangaStatusTag(status: status)
                                                        .padding(.top, 4)
                                                }
                                            }
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                }
                                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                .onPreferenceChange(ScrollOffset.self) { value in
                                    if value > 250 {
                                        selected = nil
                                    }
                                }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            GenreTags(genres: manga.genres)
                            HStack {
                                if let volumenes = manga.volumes {
                                    Text("Volúmenes: \(volumenes)")
                                }
                                Spacer()
                                if let chapters = manga.chapters {
                                    Text("Capítulos: \(chapters)")
                                }
                            }
                            .bold()
                            .padding(.trailing)
                            Text("Autores: \(manga.authors.map { "\($0.firstName) \($0.lastName)" }.joined(separator: ", "))")
                            
                            HStack {
                                
                                if manga.volumes == nil {
                                    Text("Este manga no tiene volúmenes disponibles")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.red.opacity(0.5))
                                } else {
                                    Button(action: {
                                        Task {
                                            do {
                                                try await vm.addMangaToCollection(collection: Collection(manga: manga.id, completeCollection: false, volumesOwned: [1], readingVolume: 1))
                                                await MainActor.run {
                                                    isAddedToCollection = true
                                                }
                                            } catch {
                                                isAddedToCollection = false
                                            }
                                        }
                                    }) {
                                        Text(isAddedToCollection ? "Manga en colección" : "Comenzar manga")
                                            .foregroundStyle(.white)
                                            .padding()
                                            .bold()
                                            .frame(maxWidth: .infinity)
                                            .background(isAddedToCollection ? Color.green : Color(red: 255.0 / 255.0, green: 40.0 / 255.0, blue: 84.0 / 255.0))
                                            .cornerRadius(20)
                                    }
                                    .disabled(isAddedToCollection)
                                }
                    
                            }
                            .frame(maxWidth: .infinity)
                            .padding([.top, .trailing])
                            
                            Text("Synopsis:")
                                .font(.largeTitle)
                                .bold()
                            SynopsisContent(sypnosis: manga.sypnosis)
                                .padding(.bottom, 100)
                            
                        }
                        .padding(.leading)
                    }
                    
                }
            }
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > 0 {
                            selected = nil
                        }
                    }
            )
            .overlay(alignment: .topTrailing) {
                Button {
                    selected = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                }
                .padding()
                .padding(.top, 32)
                .buttonStyle(.plain)
                .offset(x: !loaded ? 100 : selected != nil ? 0 : 100)
            }
            .navigationBarTitle(manga.title, displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button("Close") {
                selected = nil
            }
            )
        }
        .ignoresSafeArea(.all)
        .animation(.default, value: loaded)
        .onAppear {
            loaded = true
            Task {
                isAddedToCollection = false
            }
            
        }
    }
}

#Preview {
    MangaDetail(selected: .constant(.test))
}

