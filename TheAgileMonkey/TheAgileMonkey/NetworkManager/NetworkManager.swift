//
//  NetworkManager.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 15/01/21.
//

import Foundation
typealias responseCompletionType = (_ :Data)->()

protocol NetworkManagerInput: class {
    func findArtists(page: Int, name: String, completion: @escaping responseCompletionType)
    func findAlbums(artistId: Int32, completion: @escaping responseCompletionType)
    func findSongs(page: Int, albumId: Int32, completion: @escaping responseCompletionType)
}

final class NetworkManager: NetworkManagerInput {
    static let shared = NetworkManager()
    private let host = "itunes.apple.com"
    private let pageSize = 20
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        return urlComponents
    }
    
    private init() {
        
    }
    
    func findArtists(page: Int, name: String, completion: @escaping responseCompletionType) {
        let path = "search"
        let parameters = [
            "term": name,
            "limit": "\(pageSize)",
            "offset": "\(page*20)",
            "entity": "allArtist",
            "attribute": "allArtistTerm"
        ]
        
        runDataTaskForRequest(host, path: path, parameters: parameters) { (data) in
            completion(data)
        }
    }
    
    func findAlbums(artistId: Int32, completion: @escaping responseCompletionType) {
        let path = "lookup"
        let parameters = [
            "id": "\(artistId)",
            "entity": "album"
        ]
        
        runDataTaskForRequest(host, path: path, parameters: parameters) { (data) in
            completion(data)
        }
    }
    
    func findSongs(page: Int, albumId: Int32, completion: @escaping responseCompletionType) {
        let path = "lookup"
        let parameters = [
            "id": "\(albumId)",
            "limit": "\(pageSize)",
            "offset": "\(page*20)",
            "entity": "song"
        ]
        
        runDataTaskForRequest(host, path: path, parameters: parameters) { (data) in
            completion(data)
        }
    }
    
    private func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    
    /**
     Helper method to run requests. Notifies on failure via delegate.
     - parameter host: The main URL address
     - parameter path: Specific request address for a call
     - parameter parameters: Query parameters to append to the call
     - parameter completionBlock: A block to call when the request is successful and data has been retrieved.
     */
    private func runDataTaskForRequest(_ host : String, path: String, parameters: [String: String], completionBlock: @escaping (Data) -> Void) {
        
        var urlComponents = self.urlComponents
        urlComponents.host = host
        urlComponents.path = "/\(path)"
        urlComponents.setQueryItems(with: parameters)
        
        guard let url = urlComponents.url else {
            self.didFailWithError(NSError(domain: "Error getting url", code: 100, userInfo: nil))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            if let error = error {
                self?.didFailWithError(error)
                return
            }
            
            if let data = data {
                completionBlock(data)
            }
            
        }.resume()
        
    }
}
