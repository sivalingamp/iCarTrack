//
//  AccountUseCase.swift
//  CoreDataPlatform
//
//  Created by siva lingam on 15/5/21.
//

import Foundation
import Domain
import RxSwift

struct AccountUseCase: Domain.AccountUseCase, AccountRepository {
    
    func login(userName: String, password: String, rememberMe:Bool) -> Observable<LoggedInUser?> {
        
        return self.getUser(for: userName, and: password).flatMap({ account -> Observable<LoggedInUser?> in
            guard let account = account else {
                return Observable.error(NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey:"Invalid Username/Password."]))
            }
            if rememberMe == true {
                UserDefault.save(account.name, username: account.username)
            }
            return Observable.just(LoggedInUser(id: account.id, name: account.name, userName: account.username))
        })
    }
    
    func logout(userName: String) -> Observable<Void> {
        return Observable.just(UserDefault.clearUserData())
    }
    
    func getActiveAccount() -> Observable<LoggedInUser?> {
        
        return Observable.just(UserDefault.getLastLoggedInUser()).map { user in
            return user.username
        }.flatMap { userName  in
            return self.getUser(for: userName)
        }.map { account  in
            guard let account = account else { return nil }
            return LoggedInUser(id: account.id, name: account.name, userName: account.username)
        }
    }
    
    func addAccount(_ account: Account) -> Observable<Void> {
        return self.all().flatMap({ accounts -> Observable<Void> in
            if (accounts.count > 0) { return Observable.just(()) }
            return self.addUser(account)
        })
    }
    
    func accountLocations() -> Observable<[Location]> {
        return Observable.just([
            Location(country: "Singapore", code: "+65"),
            Location(country: "Malaysia", code: "+60"),
            Location(country: "China", code: "+86"),
            Location(country: "India", code: "+91")
        ])
    }
    
}
