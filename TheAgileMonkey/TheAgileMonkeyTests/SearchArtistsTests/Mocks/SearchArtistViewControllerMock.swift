//
//  SearchArtistViewControllerMock.swift
//  TheAgileMonkeyTests
//
//  Created by Christian  Collazos Castañeda on 21/01/21.
//

import Foundation
@testable import TheAgileMonkey

class SearchArtistViewControllerMock: SearchArtistViewProtocol {
    var showResultsCalled = false
    var showErrorCalled = false
    
    func showResults() {
        showResultsCalled = true
    }
    
    func showError() {
        showErrorCalled = true
    }
}
