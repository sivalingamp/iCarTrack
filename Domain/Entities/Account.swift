//
//  Account.swift
//  Domain
//
//  Created by siva lingam on 15/5/21.
//

import Foundation

public protocol CoreDataModel {
    associatedtype IDType
    static var primaryKey: String { get }
    var modelID: IDType { get }
}

// MARK: - Account
public struct Account: Codable {
    
    public let id: Int16
    public let name, username, password: String
    public let remeberMe:Bool
    
    public init(id:Int16, name:String, username:String, password:String, remeberMe:Bool = false) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
        self.remeberMe = remeberMe
    }
}

// MARK: - CoreDataModel
extension Account: CoreDataModel {
    public static var primaryKey: String {
        return "username"
    }
    
    public var modelID: String {
        return username
    }
}
