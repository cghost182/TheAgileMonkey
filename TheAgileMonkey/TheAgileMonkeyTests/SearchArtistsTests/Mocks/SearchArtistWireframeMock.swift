//
//  SearchArtistWireframeMock.swift
//  TheAgileMonkeyTests
//
//  Created by Christian  Collazos Castañeda on 21/01/21.
//

import Foundation
@testable import TheAgileMonkey

class SearchArtistWireframeMock: SearchArtistWireframing {
    static var createSearchArtistCalled = false
    var navigateToAlbumsViewCalled = false
    var artist: Artist?
    
    static func createSearchArtist() -> SearchArtistViewController {
        createSearchArtistCalled = true
        return SearchArtistViewController()
    }
    
    func navigateToAlbumsView(with artist: Artist?) {
        navigateToAlbumsViewCalled = true
        self.artist = artist
    }
}
