//
//  LoggedInUser.swift
//  Domain
//
//  Created by siva lingam on 15/5/21.
//

import Foundation

// MARK: - LoggedInUser
public struct LoggedInUser: Codable {
    let id: Int16
    public let name, username: String?
    
    public init(id:Int16, name:String, userName:String) {
        self.id = id
        self.name = name
        self.username = userName
    }
}
