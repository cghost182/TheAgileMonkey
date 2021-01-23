//
//  SearchArtistsInteractorTests.swift
//  TheAgileMonkeyTests
//
//  Created by Christian  Collazos Castañeda on 21/01/21.
//

import XCTest
@testable import TheAgileMonkey

class SearchArtistsInteractorTests: XCTestCase {

    var sut: SearchArtistInteractor!
    var presenter: SearchArtistPresenterMock!
    var networkManager: NetworkManagerMock!
    
    override func setUpWithError() throws {
        sut = SearchArtistInteractor()
        presenter = SearchArtistPresenterMock()
        networkManager = NetworkManagerMock()
        
        sut.output = presenter
        sut.networkManager = networkManager
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        presenter = nil
        try super.tearDownWithError()
    }
    
    //MARK: - searchArtistByName Tests
    func testSearchArtistByName_success() {
        //Given
        let name = "Linkin"
        let page = 0
        networkManager.responseType = .success
        
        //When
        sut.searchArtistByName(name, page: page)
        
        //Then
        XCTAssertTrue(presenter.artistsFetchedCalled)
        XCTAssertTrue(networkManager.findArtistsCalled)
        XCTAssertNotNil(presenter.artistList)
        
        if let artistList = presenter.artistList {
            XCTAssertEqual(artistList.count, 2)
            XCTAssertEqual(artistList[0].artistName, "LINKIN PARK")
            XCTAssertEqual(artistList[1].artistName, "Linkin Bridge")
        }
    }
    
    func testSearchArtistByName_failWithEmptyResponse() {
        //Given
        let name = "Linkin"
        let page = 0
        networkManager.responseType = .errorWithEmptyResponse
        
        //When
        sut.searchArtistByName(name, page: page)
        
        //Then
        XCTAssertTrue(presenter.artistsFetchedCalled)
        XCTAssertTrue(networkManager.findArtistsCalled)
        XCTAssertNotNil(presenter.artistList)
    }
    
    func testSearchArtistByName_failWithInvalidJSON() {
        //Given
        let name = "Linkin"
        let page = 0
        networkManager.responseType = .errorWithInvalidJson
        
        //When
        sut.searchArtistByName(name, page: page)
        
        //Then
        XCTAssertTrue(presenter.artistNotFoundCalled)
        XCTAssertTrue(networkManager.findArtistsCalled)
        XCTAssertNil(presenter.artistList)
    }
}
