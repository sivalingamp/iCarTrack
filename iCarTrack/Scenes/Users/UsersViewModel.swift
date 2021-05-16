//
//  UsersViewModel.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import RxCocoa
import Domain

class UsersViewModel: ViewModelType {
    
    private let usersUseCase: UsersUseCase
    private let accountUseCase: AccountUseCase
    private let router: UsersRouter
    private let userName:String
    
    init(userName:String, accountUseCase:AccountUseCase, usersUseCase:UsersUseCase, router:UsersRouter) {
        self.userName = userName
        self.usersUseCase = usersUseCase
        self.accountUseCase = accountUseCase
        self.router = router
    }
    
    // internal
    func transform(_ input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let users = input.trigger.flatMap {[unowned self] _ in
            return self.usersUseCase.users().trackActivity(activityIndicator).trackError(errorTracker).asDriverOnErrorJustComplete()
        }
        
        let logout = input.logoutTrigger.flatMap { [unowned self] _ in
            return self.accountUseCase.logout(userName: self.userName).asDriverOnErrorJustComplete()
        }.do {[unowned self] _ in
            self.router.logout()
        }
        
        let select = input.selectionTrigger.flatMap { index in
            return Driver.zip(Driver.just(index), users)
        }.map { data in
            return data.1[data.0.row]
        }.do {[unowned self] user in
            self.router.toUserDetail(userDetail: user)
        }.mapToVoid()

        
        return Output(logout: logout,
                      data: users,
                      error: errorTracker.asDriver(),
                      loading: activityIndicator.asDriver(),
                      selection: select)
    }
    
}

extension UsersViewModel {
    
    // input
    struct Input {
        let trigger:Driver<Void>
        let selectionTrigger:Driver<IndexPath>
        let logoutTrigger:Driver<Void>
    }
    // output
    struct Output {
        let logout:Driver<Void>
        let data:Driver<[UserDetail]>
        let error:Driver<Error>
        let loading:Driver<Bool>
        let selection:Driver<Void>
    }
}

