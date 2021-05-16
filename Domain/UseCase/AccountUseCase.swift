//
//  AccountUseCase.swift
//  Domain
//
//  Created by siva lingam on 15/5/21.
//

import Foundation
import RxSwift

public protocol AccountUseCase {
    func addAccount(_ account:Account) -> Observable<Void>
    func login(userName:String, password:String, rememberMe:Bool) -> Observable<LoggedInUser?>
    func logout(userName:String) -> Observable<Void>
    func getActiveAccount() -> Observable<LoggedInUser?>
    func accountLocations() -> Observable<[Location]>
}
