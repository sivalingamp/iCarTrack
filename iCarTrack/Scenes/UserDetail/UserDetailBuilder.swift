//
//  UsersBuilder.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Domain

struct UserDetailBuilder {

    static func viewController(user:UserDetail) -> UIViewController {
        let router = UserDetailRouter()
        let useCaseProvider = Application.shared.useCaseProvider
        let viewModel = UserDetailViewModel(userDetail: user, router: router)
        let viewController = UserDetailViewController(withViewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
