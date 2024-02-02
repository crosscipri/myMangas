//
//  MangaCollectionDetail.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 27/1/24.
//

import SwiftUI

struct MangaCollectionDetail: View {
    @StateObject var mangasVM = MangasVM()

    let mangaCollection: MangaCollection
    
    @Binding var path: [MangaCollection]
    @State private var selectedTab = 0
    
    @State private var myVolumes: [Int]
      @State private var readingVolume: Int

      init(mangaCollection: MangaCollection, path: Binding<[MangaCollection]>) {
          self.mangaCollection = mangaCollection
          _path = path
          _myVolumes = State(initialValue: mangaCollection.volumesOwned)
          _readingVolume = State(initialValue: mangaCollection.readingVolume)
      }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let urlStringOptional = mangaCollection.manga.mainPicture,
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
                                    Text(mangaCollection.manga.title)
                                        .font(.title)
                                    Text("(\(mangaCollection.manga.titleJapanese))")
                                        .font(.title3)
                                    if !mangaCollection.manga.demographics.isEmpty {
                                        Text("\(mangaCollection.manga.demographics.map { $0.demographic }.joined(separator: ", "))")
                                            .font(.subheadline)
                                    }
                                    StarRating(rating: mangaCollection.manga.score)
                                    Text("Inicio: \(formatDate(mangaCollection.manga.startDate))")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    if let endDate = mangaCollection.manga.endDate {
                                        Text("Fin: \(formatDate(endDate))")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    if let status = PublishingStatus(rawValue: mangaCollection.manga.status) {
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
                
            }
            VStack(alignment: .leading, spacing: 8) {
                GenreTags(genres: mangaCollection.manga.genres)
                HStack {
                    if let volumenes = mangaCollection.manga.volumes {
                        Text("Volúmenes: \(mangaCollection.volumesOwned.count)/\(volumenes)")
                    }
                    Spacer()
                    if let chapters = mangaCollection.manga.chapters {
                        Text("Capítulos: \(chapters)")
                    }
                }
                .bold()
                .padding(.trailing)
                Text("Autores: \(mangaCollection.manga.authors.map { "\($0.firstName) \($0.lastName)" }.joined(separator: ", "))")
                
                Picker("", selection: $selectedTab) {
                    Text("Volúmenes").tag(0)
                    Text("Synopsis").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.top, .trailing])
                
                if selectedTab == 1 {
                    SynopsisContent(sypnosis: mangaCollection.manga.sypnosis)
                        .padding(.bottom, 100)
                } else if selectedTab == 0 {
                    VolumeList(volumes: mangaCollection.manga.volumes ?? 0, myVolumes: $myVolumes, readingVolume: $readingVolume)
                        .listStyle(PlainListStyle())
                        .padding(.bottom, 100)
                        .onChange(of: myVolumes) {
                            let isComplete = myVolumes.count == mangaCollection.manga.volumes
                            let collection = Collection(manga: mangaCollection.manga.id, completeCollection: isComplete, volumesOwned: myVolumes, readingVolume: readingVolume)
                            Task {
                                await mangasVM.addMangaToCollection(collection: collection)
                            }
                        }
                        .onChange(of: readingVolume) {
                            let isComplete = myVolumes.count == mangaCollection.manga.volumes
                            let collection = Collection(manga: mangaCollection.manga.id, completeCollection: isComplete, volumesOwned: myVolumes, readingVolume: readingVolume)
                            Task {
                                await mangasVM.addMangaToCollection(collection: collection)
                            }
                        }
                }
            
        
            }
            .padding(.leading)
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
  
    }
}

#Preview {
    NavigationStack {
        MangaCollectionDetail(mangaCollection: .collectionTest, path: .constant([]))
    }}
