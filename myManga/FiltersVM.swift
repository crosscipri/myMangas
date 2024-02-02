//
//  FiltersVM.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 8/1/24.
//

import Foundation

final class FiltersVM: ObservableObject {
    let interactor: DataInteractor

    @Published var authors: [Author] = []
    @Published var authorsByName: [Author] = []
    @Published var demographics: [String] = []
    @Published var genres: [String] = []
    @Published var themes: [String] = []
    @Published var isLoading = false
    @Published var errorMsg = ""
    @Published var showAlert = false

    @ObservationIgnored var ignored = 20
    
    init(interactor: DataInteractor = Network.shared) {
        self.interactor = interactor
    }
    
    func getAuthors() async {
        isLoading = true
        do {
            let authors = try await interactor.getAuthors()
            await MainActor.run {
                self.authors = authors
                print(self.authors)
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
    
    func getAuthorsByName(name: String) async {
        isLoading = true
        do {
            let authors = try await interactor.getAuthorsByName(name: name)
            await MainActor.run {
                self.authorsByName = authors
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
    
    func getDemographics() async {
        isLoading = true
        do {
            let demographics = try await interactor.getDemographics()
            await MainActor.run {
                self.demographics = demographics
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
    
    func getGenres() async {
        isLoading = true
        do {
            let genres = try await interactor.getGenres()
            await MainActor.run {
                self.genres = genres
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
    
    func getThemes() async {
        isLoading = true
        do {
            let themes = try await interactor.getThemes()
            await MainActor.run {
                self.themes = themes
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
    
}
