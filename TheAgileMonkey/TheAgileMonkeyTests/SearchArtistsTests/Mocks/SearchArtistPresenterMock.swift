//
//  SearchArtistPresenterMock.swift
//  TheAgileMonkeyTests
//
//  Created by Christian  Collazos Castañeda on 21/01/21.
//

import Foundation
@testable import TheAgileMonkey

class SearchArtistPresenterMock: SearchArtistInteractorOutput {
    var artistsFetchedCalled = false
    var artistNotFoundCalled = false
    var artistList: [Artist]?
    
    func artistsFetched(_ artistList: [Artist]?) {
        artistsFetchedCalled = true
        self.artistList = artistList
    }
    
    func artistNotFound() {
        artistNotFoundCalled = true
    }
}
