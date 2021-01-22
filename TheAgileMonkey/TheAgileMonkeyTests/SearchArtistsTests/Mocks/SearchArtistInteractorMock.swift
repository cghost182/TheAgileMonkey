//
//  SearchArtistInteractorMock.swift
//  TheAgileMonkeyTests
//
//  Created by Christian  Collazos Castañeda on 21/01/21.
//

import Foundation
@testable import TheAgileMonkey

class SearchArtistInteractorMock: SearchArtistInteractorInput {
    var searchArtistByNameCalled = false
    var artistName = ""
    var page = 0
    
    func searchArtistByName(_ name: String, page: Int) {
        searchArtistByNameCalled = true
        artistName = name
        self.page = page
    }
}
