//
//  LoginRouter.swift
//  iCarTrack
//
//  Created by siva lingam on 13/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
class LoginRouter {
    
    weak var viewController: LoginViewController?

    func toMain(userName:String) {
        let homeScreen = UsersBuilder.viewController(userName: userName)
        let navController = UINavigationController(rootViewController: homeScreen)
        navController.modalPresentationStyle = .fullScreen
        self.viewController?.present(navController, animated: true, completion: nil)
    }
}

