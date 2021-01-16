//
//  URLComponentsExtension.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 15/01/21.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
}
