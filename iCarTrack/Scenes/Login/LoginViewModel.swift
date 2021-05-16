//
//  LoginViewModel.swift
//  iCarTrack
//
//  Created by siva lingam on 13/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import RxCocoa
import Domain

class LoginViewModel: ViewModelType {
    
    private let useCase: AccountUseCase
    private let router: LoginRouter
    
    init(useCase:AccountUseCase, router:LoginRouter) {
        self.useCase = useCase
        self.router = router
    }
    
    // internal
    func transform(_ input: Input) -> Output {
        
        let addUserAccount = input.trigger.flatMap {[unowned self] _ in
            return self.useCase.addAccount(Account(id: 1, name: "Siva", username: "siva", password: "password123")).asDriverOnErrorJustComplete()
        }.mapToVoid()
        
        let activeAccount = addUserAccount.flatMap { _ in
            return self.useCase.getActiveAccount().asDriverOnErrorJustComplete()
        }.filter { $0 != nil }
        .do { user in
            self.router.toMain(userName: user?.username ?? "")
        }

        let rememberMe = input.rememberMeTrigger.scan(false) { state, _ in
            return !state
        }.startWith(false)
        
        let userNameAndPassword = Driver.combineLatest(input.userName, input.password, rememberMe)
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let canSubmit = Driver.combineLatest(userNameAndPassword, activityIndicator.asDriver()) {
            return !$0.0.isEmpty && !$0.1.isEmpty && !$1
        }
        
        let countries = input.countryTrigger.flatMap {_ in
            return self.useCase.accountLocations().asDriverOnErrorJustComplete()
        }.map { locations -> [String] in
            return locations.map { $0.country }
        }
        
        let save = input.loginTrigger.withLatestFrom(userNameAndPassword)
            .flatMapLatest { [unowned self] in
                return self.useCase.login(userName: $0.0, password: $0.1, rememberMe:$0.2).trackActivity(activityIndicator)
                    .trackError(errorTracker).asDriverOnErrorJustComplete()
            }.do { [unowned self] user in
                self.router.toMain(userName: user?.username ?? "")
            }
        
        let proceed = Driver.merge(save, activeAccount)
        
        return Output(trigger:addUserAccount, country: countries,
                      rememberMe: rememberMe,
                      proceed: proceed, error: errorTracker.asDriver(),
                      loading: activityIndicator.asDriver(), canSubmit: canSubmit)
    }
    
}

extension LoginViewModel {
    
    // input
    struct Input {
        let trigger:Driver<Void>
        let userName:Driver<String>
        let password:Driver<String>
        let country:Driver<String>
        let countryTrigger:Driver<Void>
        let loginTrigger:Driver<Void>
        let rememberMeTrigger:Driver<Void>
    }
    // output
    struct Output {
        let trigger:Driver<Void>
        let country:Driver<[String]>
        let rememberMe:Driver<Bool>
        let proceed:Driver<LoggedInUser?>
        let error:Driver<Error>
        let loading:Driver<Bool>
        let canSubmit:Driver<Bool>
    }
    
}

