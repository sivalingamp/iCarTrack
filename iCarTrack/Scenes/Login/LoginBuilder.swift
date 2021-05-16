//
//  LoginBuilder.swift
//  iCarTrack
//
//  Created by siva lingam on 13/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Domain

struct LoginBuilder {

    static func viewController(service:UseCaseProvider) -> UIViewController {
        let router = LoginRouter()
        let viewModel = LoginViewModel(useCase: service.makeAccountUseCase(), router: router)
        let viewController = LoginViewController(withViewModel: viewModel, router: router)
        router.viewController = viewController
        return viewController
    }
}
