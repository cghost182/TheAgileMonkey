//
//  Artist.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 15/01/21.
//

import Foundation

struct ArtistResponse: Codable {
    let resultCount: Int?
    let results: [Artist]?
}

struct Artist: Codable {
    let artistId: Int32?
    let artistName: String?
    let primaryGenreName: String?
}
