//
//  NetworkManagerMock.swift
//  TheAgileMonkeyTests
//
//  Created by Christian  Collazos Castañeda on 21/01/21.
//

import Foundation
@testable import TheAgileMonkey

enum FindArtistResponseTestType {
    case success
    case errorWithEmptyResponse
    case errorWithInvalidJson
}

class NetworkManagerMock: NetworkManagerInput {
    var findArtistsCalled = false
    var responseType: FindArtistResponseTestType?
    
    func findArtists(page: Int, name: String, completion: @escaping responseCompletionType) {
        findArtistsCalled = true
        
        switch responseType {
        case .success:
            completion(createArtistResponse())
        case .errorWithEmptyResponse:
            completion(createEmptyResponse())
        case .errorWithInvalidJson:
            completion(createInvalidJSONResponse())
        default:
            completion(Data())
        }
    }
    
    func findAlbums(artistId: Int32, completion: @escaping responseCompletionType) {
        
    }
    
    func findSongs(page: Int, albumId: Int32, completion: @escaping responseCompletionType) {
        
    }
    
    //MARK: - Helpers
    func createArtistResponse() -> Data {
        let artists = """
                {
                    "resultCount":5,
                    "results": [
                        {"wrapperType":"artist", "artistType":"Artist", "artistName":"LINKIN PARK", "artistLinkUrl":"https://music.apple.com/us/artist/linkin-park/148662?uo=4", "artistId":148662, "amgArtistId":447095, "primaryGenreName":"Hard Rock", "primaryGenreId":1152
                        },
                        {"wrapperType":"artist", "artistType":"Artist", "artistName":"Linkin Bridge", "artistLinkUrl":"https://music.apple.com/us/artist/linkin-bridge/1066354936?uo=4", "artistId":1066354936, "primaryGenreName":"Pop", "primaryGenreId":14
                        }
                    ]
                }
                """
        
        return  Data(artists.utf8)
    }
    
    func createEmptyResponse() -> Data {
        let artists = """
                        {
                         "resultCount":0,
                         "results": []
                        }
                      """
        
        return  Data(artists.utf8)
    }
    
    func createInvalidJSONResponse() -> Data {
        let artists = """
                        {"invalid
                      """
        
        return  Data(artists.utf8)
    }
}

