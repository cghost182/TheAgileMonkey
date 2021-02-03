//
//  Song.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 16/01/21.
//

import Foundation

struct SongResponse: Codable {
    let resultCount: Int?
    let results: [Song]?
}

struct Song: Codable {
    let wrapperType: String?
    let kind: String?
    let trackId: Int32?
    let trackName: String?
    let previewUrl: String?
    let trackViewUrl: String?
    let artworkUrl100: String?
    var isFavorite: Bool?
}
