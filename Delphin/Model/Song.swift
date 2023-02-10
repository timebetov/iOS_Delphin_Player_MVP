//
//  Song.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import Foundation

struct Song {
    let title: String
    let author: String
    let duration: Double
    var isFav: Bool = false
}

extension Song {
    static let mockSongs = [
        Song(title: "Jocelyn Flores", author: "XXXTentacion", duration: 1.59),
        Song(title: "Middle Of The Night", author: "Elley Duhé", duration: 4.10, isFav: false)
    ]
}
