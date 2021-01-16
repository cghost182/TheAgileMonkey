//
//  Album.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 15/01/21.
//

import Foundation

struct Album: Codable {
    let resultCount: Int?
    let results: [AlbumResult]?
}

struct AlbumResult: Codable {
    let wrapperType: String?
    let collectionId: Int32?
    let collectionName: String?
    let artworkUrl60: String?
    let releaseDate: String?
}
