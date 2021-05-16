//
//  UseCaseProvider.swift
//  Domain
//
//  Created by siva lingam on 13/5/21.
//

import Foundation

public protocol UseCaseProvider {
    func makeUsersUseCase() -> UsersUseCase
    func makeAccountUseCase() -> AccountUseCase
}
