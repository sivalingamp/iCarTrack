//
//  UseCaseProvider.swift
//  DataPlatform
//
//  Created by siva lingam on 13/5/21.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {

    public init() { }
    
    public func makeUsersUseCase() -> Domain.UsersUseCase {
        return UsersUseCase()
    }
    
    public func makeAccountUseCase() -> Domain.AccountUseCase {
        return AccountUseCase()
    }
}
