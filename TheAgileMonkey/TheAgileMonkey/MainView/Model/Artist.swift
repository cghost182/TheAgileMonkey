//
//  Artist.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 15/01/21.
//

import Foundation

struct Artist: Codable {
    let resultCount: Int?
    let results: [ArtistResult]?
}

struct ArtistResult: Codable {
    let artistId: Int32?
    let artistName: String?
    let primaryGenreName: String?
}
