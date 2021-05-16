//
//  UsersUseCase.swift
//  DataPlatform
//
//  Created by siva lingam on 13/5/21.
//

import Foundation
import Domain
import RxSwift

struct UsersUseCase: Domain.UsersUseCase {
    
    func users() ->  Observable<[UserDetail]> {
        return Observable.create { observer in
            let request = apiProvider.request(.getUsers) { result in
                switch result {
                case .success(let response):
                    do {
                        let users =  try JSONDecoder().decode(UserDetailList.self, from: response.data)
                        observer.onNext(users)
                    }catch {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

