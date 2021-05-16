//
//  UserDetail.swift
//  Domain
//
//  Created by siva lingam on 13/5/21.
//

import Foundation

// MARK: - UserDetailElement
public struct UserDetail: Codable {
    let id: Int
    public let name, username, email: String?
    public let address: Address?
    public let phone, website: String?
    public let company: Company?
}

// MARK: - Address
public struct Address: Codable {
    let street, suite, city, zipcode: String?
    public let geo: Geo?
    
    public func details() -> String {
        return "\(street ?? "") \(city ?? "") - \(zipcode ?? "")"
    }
}

// MARK: - Geo
public struct Geo: Codable {
    public let lat, lng: String?
}

// MARK: - Company
public struct Company: Codable {
    let name, catchPhrase, bs: String?
    
    public func details() -> String {
        return "\(name ?? "")"
    }
}

public typealias UserDetailList = [UserDetail]
