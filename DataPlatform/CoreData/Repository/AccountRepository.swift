//
//  AccountRepository.swift
//  DataPlatform
//
//  Created by siva lingam on 15/5/21.
//

import Foundation
import RxSwift
import Domain

protocol AccountRepository: CoreDataRepository {
    func addUser(_ user: Account) -> Observable<Void>
    func getUser(for username:String, and password:String) -> Observable<Account?>
    func getUser(for username:String) -> Observable<Account?>
    func updateUser(_ user: Account) -> Observable<Void>
    func getLastActiveUser() -> Observable<Account?>
}

extension AccountRepository where Self.ModelType == Account, Self.EntityType == CDUser {
    
    func getUser(for username:String, and password:String) -> Observable<Account?> {
        return self.item(with: NSPredicate(format: "username == %@ AND password == %@", username, password))
    }
    
    func getLastActiveUser() -> Observable<Account?> {
        return self.item(with: NSPredicate(format: "active == true"))
    }
    
    func getUser(for username:String) -> Observable<Account?> {
        return self.item(with: NSPredicate(format: "username == %@", username))
    }
    
    func addUser(_ user: Account) -> Observable<Void> {
        return self.add(user)
    }
    
    func updateUser(_ user: Account) -> Observable<Void> {
        return self.update(user)
    }
    static func map(from item: Account, to entity: CDUser) {
        entity.userId = item.id
        entity.name = item.name
        entity.username = item.username
        entity.password = item.password
        entity.remeberMe = item.remeberMe
    }
    
    static func item(from entity: CDUser) -> Account? {
        guard let uName = entity.username else { return nil }
        return Account(id: entity.userId,
                       name: entity.name ?? "",
                       username: uName,
                       password: entity.password ?? "")
    }
    
}

