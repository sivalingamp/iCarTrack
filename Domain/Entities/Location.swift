//
//  Location.swift
//  Domain
//
//  Created by siva lingam on 15/5/21.
//

import Foundation

// MARK: - Location
public struct Location: Codable {
    public let country: String
    public let code: String
    
    public init(country:String, code:String) {
        self.country = country
        self.code = code
    }
}
