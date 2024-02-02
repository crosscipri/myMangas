//
//  MangasVM.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 27/12/23.
//

import Foundation

final class MangasVM: ObservableObject {
    let interactor: DataInteractor

    @Published var mangas = MangasLogic()
    @Published var collection: [MangaCollection] = []
    @Published var showAlert = false
    @Published var errorMsg = ""
    @Published var currentPage = 1
    @Published var isLoading = false
    
    @ObservationIgnored var ignored = 20
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
        Task {
            await getAllMangas()
        }
    }
    
    func getAllMangas() async {
        isLoading = true
        do {
            let mangas = try await interactor.getAllMangas(page: currentPage)
            await MainActor.run {
                self.mangas.mangas.append(contentsOf: mangas.items)
                self.currentPage += 1
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMsg = "\(error)"
                self.showAlert.toggle()
                self.isLoading = false
            }
        }
    }
    
    func getBestMangas() async {
        isLoading = true
        do {
            let newMangas = try await interactor.getBestMangas(page: currentPage)
            await MainActor.run {
                self.mangas.mangas.append(contentsOf: newMangas.items)
                self.currentPage += 1
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMsg = "\(error)"
                self.showAlert.toggle()
                self.isLoading = false
            }
        }
    }
    
    func searchMangasByFilters(filters: CustomSearch) async {
        isLoading = true
        do {
            let mangas = try await interactor.searchMangasByFilters(filters: filters)
            await MainActor.run {
                print("mangas",  mangas.items)
                self.mangas.mangas.append(contentsOf: mangas.items)
                self.currentPage += 1
                self.isLoading = false
            }
        } catch {
            self.errorMsg = "\(error)"
            self.showAlert.toggle()
            self.isLoading = false
        }
    }
    
    func addMangaToCollection(collection: Collection) async {
        isLoading = true
        do {
            try await interactor.addMangaToCollection(collection: collection)
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            self.errorMsg = "\(error)"
            self.showAlert.toggle()
            self.isLoading = false
        }
        
    }
    
    func getMangasCollection() async {
        isLoading = true
        do {
            let mangasCollection = try await interactor.getMangaCollection()
            await MainActor.run {
                self.collection = mangasCollection
                self.isLoading = false
            }
        } catch {
            self.errorMsg = "\(error)"
            self.showAlert.toggle()
            self.isLoading = false
        }
    }
    
    func deleteMangaCollection(id: Int) async {
        isLoading = true
        
        do {
            try await interactor.deleteMangaCollection(id: id)
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            self.errorMsg = "\(error)"
            self.showAlert.toggle()
            self.isLoading = false
        }
    }
    
    func isMangaInCollection(mangaId: Int) -> Bool {
        print("col", collection)
        for mangaCollection in collection {
            if mangaCollection.manga.id == mangaId {
                return true
            }
        }
        return false
    }
}
