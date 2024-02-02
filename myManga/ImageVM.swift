//
//  ImageVM.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 27/12/23.
//

import SwiftUI


final class ImageVM: ObservableObject {
    @Published var image: UIImage?
    
    let interactor: ImageInteractor
    
    init(interactor: ImageInteractor = ImageManager()) {
        self.interactor = interactor
    }
    
    func getImage(url: URL?) throws {
        guard let url else { return }
        let imageURL = URL.cachesDirectory.appending(path: url.lastPathComponent)
        if FileManager.default.fileExists(atPath: imageURL.path()) {
            let data = try Data(contentsOf: imageURL)
            image = UIImage(data: data)
        } else {
            Task {
                let image = try await interactor.getImage(url: url)
                await MainActor.run {
                    self.image = image
                }
            }
        }
    }
}
