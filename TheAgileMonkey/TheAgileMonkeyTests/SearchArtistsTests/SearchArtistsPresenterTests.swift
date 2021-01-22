//
//  SearchArtistsPresenterTests.swift
//  TheAgileMonkeyTests
//
//  Created by Christian  Collazos Castañeda on 15/01/21.
//

import XCTest
@testable import TheAgileMonkey

class SearchArtistsPresenterTests: XCTestCase {

    var sut: SearchArtistPresenter!
    var view: SearchArtistViewControllerMock!
    var interactor: SearchArtistInteractorMock!
    var wireframe: SearchArtistWireframeMock!
    
    override func setUpWithError() throws {
        sut = SearchArtistPresenter()
        view = SearchArtistViewControllerMock()
        interactor = SearchArtistInteractorMock()
        wireframe = SearchArtistWireframeMock()
        
        sut.view = view
        sut.interactor = interactor
        sut.wireframe = wireframe
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        view = nil
        interactor = nil
        wireframe = nil
        
        try super.tearDownWithError()
    }

    //MARK: - searchArtistByName Tests
    func testSearchArtistByName() {
        //Given
        let name = "Michael"
        
        //When
        sut.searchArtistByName(name)
        
        //Then
        XCTAssertTrue(interactor.searchArtistByNameCalled)
        XCTAssertEqual(interactor.artistName, name)
        XCTAssertEqual(interactor.page, 0)
    }
    
    //MARK: - resetArtistList Tests
    func testResetArtistList() {
        //When
        sut.resetArtistList()
        
        //Then
        XCTAssertTrue(sut.artistList.isEmpty)
        XCTAssertTrue(view.showResultsCalled)
    }
    
    //MARK: - loadMoreArtists Tests
    func testLoadMoreArtists_withNoName() {
        //When
        sut.loadMoreArtists()
        
        //Then
        XCTAssertTrue(interactor.searchArtistByNameCalled)
        XCTAssertTrue(interactor.artistName.isEmpty)
        XCTAssertEqual(interactor.page, 1)
    }
    
    func testLoadMoreArtists_withName() {
        //Given
        let name = "Michael"
        sut.searchArtistByName(name)
        
        //When
        sut.loadMoreArtists()
        
        //Then
        XCTAssertTrue(interactor.searchArtistByNameCalled)
        XCTAssertNotNil(interactor.artistName)
        XCTAssertEqual(interactor.artistName, name)
        XCTAssertEqual(interactor.page, 1)
    }
    
    func testLoadMoreArtists_paginating() {
        //Given
        let name = "Michael"
        sut.searchArtistByName(name)
        
        //When
        sut.loadMoreArtists()
        sut.loadMoreArtists()
        sut.loadMoreArtists()
        
        //Then
        XCTAssertTrue(interactor.searchArtistByNameCalled)
        XCTAssertNotNil(interactor.artistName)
        XCTAssertEqual(interactor.artistName, name)
        XCTAssertEqual(interactor.page, 3)
    }
    
    func testLoadMoreArtists_paginatingReseted() {
        //Given
        let name = "Michael"
        sut.searchArtistByName(name)
        
        //When
        sut.loadMoreArtists()
        sut.loadMoreArtists()
        sut.loadMoreArtists()
        sut.searchArtistByName(name)
        sut.loadMoreArtists()
        
        //Then
        XCTAssertTrue(interactor.searchArtistByNameCalled)
        XCTAssertNotNil(interactor.artistName)
        XCTAssertEqual(interactor.artistName, name)
        XCTAssertEqual(interactor.page, 1)
    }
    
    //MARK: - navigateToAlbumsView Tests
    func testNavigateToAlbumsView_withNoArtist() {
        //When
        sut.navigateToAlbumsView(with: nil)
        
        //Then
        XCTAssertTrue(wireframe.navigateToAlbumsViewCalled)
        XCTAssertNil(wireframe.artist)
    }
    
    func testNavigateToAlbumsView_withArtist() {
        //Given
        let artist = createArtist()
        
        //When
        sut.navigateToAlbumsView(with: artist)
        
        //Then
        XCTAssertTrue(wireframe.navigateToAlbumsViewCalled)
        XCTAssertNotNil(wireframe.artist)
        XCTAssertEqual(wireframe.artist?.artistId, artist.artistId)
        XCTAssertEqual(wireframe.artist?.artistName, artist.artistName)
        XCTAssertEqual(wireframe.artist?.primaryGenreName, artist.primaryGenreName)
    }
    
    //MARK: - artistsFetched Tests
    func testArtistsFetched_withNoData() {
        //When
        sut.artistsFetched(nil)
        
        //Then
        XCTAssertTrue(view.showErrorCalled)
        XCTAssertFalse(view.showResultsCalled)
        XCTAssertTrue(sut.artistList.isEmpty)
    }
    
    func testArtistsFetched_withEmptyData() {
        //When
        sut.artistsFetched([])
        
        //Then
        XCTAssertTrue(view.showErrorCalled)
        XCTAssertFalse(view.showResultsCalled)
        XCTAssertTrue(sut.artistList.isEmpty)
    }
    
    func testArtistsFetched_withData_andPage0() {
        //Given
        let artists = [createArtist(), createArtist()]
        
        //When
        sut.artistsFetched(artists)
        
        //Then
        XCTAssertFalse(view.showErrorCalled)
        XCTAssertTrue(view.showResultsCalled)
        XCTAssertTrue(sut.artistList.count == 2)
    }
    
    func testArtistsFetched_withData_andPage1() {
        //Given
        let artists = [createArtist(), createArtist()]
        let name = "Michael"
        sut.searchArtistByName(name)
        
        //When
        sut.artistsFetched(artists)
        sut.loadMoreArtists()
        sut.artistsFetched(artists)
        
        //Then
        XCTAssertFalse(view.showErrorCalled)
        XCTAssertTrue(view.showResultsCalled)
        XCTAssertTrue(sut.artistList.count == 4)
    }
    
    //MARK: - artistNotFound Tests
    func testArtistNorFound() {
        //When
        sut.artistNotFound()
        
        //Then
        XCTAssertTrue(view.showErrorCalled)
    }
    
    
    //MARK: - Helpers
    func createArtist() -> Artist {
        return Artist(artistId: 12345, artistName: "Michael Jackson", primaryGenreName: "Pop")
    }
    
    
    //TODO: mock networkManager to test interactor
}
