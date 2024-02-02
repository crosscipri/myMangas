//
//  PreviewData.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 2/1/24.
//

import SwiftUI

extension Item {
    static let test = Item(
        authors: [
            Author(id: "6F0B6948-08C4-4761-8BE1-192E68AB0A2F",  role: "Story & Art", lastName: "Miura", firstName: "Kentarou"),
            Author(id: "0304C4E9-2D89-463A-8FDD-EEAB5B9D57B3",  role: "Art", lastName: "Studio Gaga", firstName: "")
        ],
        volumes: 22,
        endDate: nil,
        title: "Berserk",
        genres: [
            Genre(genre: "Action", id: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD"),
            Genre(genre: "Adventure", id: "BE70E289-D414-46A9-8F15-928EAFBC5A32"),
            Genre(genre: "Award Winning", id: "4C13067F-96FF-4F14-A1C0-B33215F24E0B"),
            Genre(genre: "Drama", id: "4312867C-1359-494A-AC46-BADFD2E1D4CD"),
            Genre(genre: "Fantasy", id: "B3E8D4B2-7EE4-49CD-8DB0-9897619B3F62"),
            Genre(genre: "Horror", id: "3B6A9037-3F61-4483-AD8A-E43365C5C953"),
            Genre(genre: "Supernatural", id: "AE80120B-6659-4C0E-AEB2-227EC25EC4AF")
        ],
        url: "https://myanimelist.net/manga/2/Berserk",
        titleEnglish: "Berserk",
        chapters: 142,
        score: 9.47,
        startDate: "1989-08-25T00:00:00Z",
        sypnosis: "Kenzou Tenma, a renowned Japanese neurosurgeon working in post-war Germany, faces a difficult choice: to operate on Johan Liebert, an orphan boy on the verge of death, or on the mayor of Düsseldorf. In the end, Tenma decides to gamble his reputation by saving Johan, effectively leaving the mayor for dead.\n\nAs a consequence of his actions, hospital director Heinemann strips Tenma of his position, and Heinemann's daughter Eva breaks off their engagement. Disgraced and shunned by his colleagues, Tenma loses all hope of a successful career—that is, until the mysterious killing of Heinemann gives him another chance.\n\nNine years later, Tenma is the head of the surgical department and close to becoming the director himself. Although all seems well for him at first, he soon becomes entangled in a chain of gruesome murders that have taken place throughout Germany. The culprit is a monster—the same one that Tenma saved on that fateful day nine years ago.\n\n[Written by MAL Rewrite]",
        background: "Berserk won the Award for Excellence at the sixth installment of Tezuka Osamu Cultural Prize in 2002. The series...",
        status: "currently_publishing",
        titleJapanese: "ベルセルク",
        themes: [
            Theme(theme: "Gore", id: "82728A80-0DBE-4B64-A295-A25555A4A4A5"),
            Theme(theme: "Military", id: "AD119CBB-2CCE-42FE-BD89-32D42C46462F"),
            Theme(theme: "Mythology", id: "AD7A66B1-D066-4BC0-8AEE-7B97904F003A"),
            Theme(theme: "Psychological", id: "4394C99F-615B-494A-929E-356A342A95B8")
        ],
        id: 2,
        demographics: [
            DemographicElement(id: UUID(uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D")!, demographic: "Seinen")
        ],
        mainPicture: "https://cdn.myanimelist.net/images/manga/1/157897l.jpg"
    )
}

struct ImageTest: ImageInteractor {
    func getImage(url: URL) async throws -> UIImage? {
        let file = url.lastPathComponent
        return UIImage(named: file)
    }
}

extension ImageVM {
    static let test = ImageVM(interactor: ImageTest())
}

extension MangaCollection {
    static let collectionTest = MangaCollection(
        user: User(id: "9C1DADCA-3D87-4050-B6E2-8EB9E3500607"),
        volumesOwned: [
            1,
            2,
            3,
            4,
            5,
            6
        ],
        readingVolume: 4,
        id: "87BA97BD-A79D-494D-B4FE-A46841D89753",
        completeCollection: false,
        manga: .test
    )
}
