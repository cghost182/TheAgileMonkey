//
//  Song.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 16/01/21.
//

import Foundation

struct Song: Codable {
    let resultCount: Int?
    let results: [SongResult]?
}

struct SongResult: Codable {
    let wrapperType: String?
    let trackId: Int32?
    let trackName: String?
    let previewUrl: String?
}
