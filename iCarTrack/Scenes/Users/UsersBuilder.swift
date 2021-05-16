//
//  UsersBuilder.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct UsersBuilder {

    static func viewController(userName:String) -> UIViewController {
        let router = UsersRouter()
        let useCaseProvider = Application.shared.useCaseProvider
        let viewModel = UsersViewModel(userName: userName, accountUseCase: useCaseProvider.makeAccountUseCase(),
                                       usersUseCase: useCaseProvider.makeUsersUseCase(),
                                       router: router)
        let viewController = UsersViewController(withViewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
