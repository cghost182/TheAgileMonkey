//
//  StringExtension.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 18/01/21.
//

import Foundation

extension String {
    func getDateFromString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZ"
        
        guard let formattedDate = dateFormatter.date(from: self) else { return self }
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let resultDate = dateFormatter.string(from: formattedDate)
        
        return resultDate
    }
}
