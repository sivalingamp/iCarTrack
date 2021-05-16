//
//  UserListUseCase.swift
//  Domain
//
//  Created by siva lingam on 13/5/21.
//

import Foundation
import RxSwift

public protocol UsersUseCase {
    func users() -> Observable<[UserDetail]>
}
