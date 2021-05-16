//
//  UsersRouter.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Domain

class UsersRouter {
    weak var viewController: UsersViewController?

    func toUserDetail(userDetail:UserDetail) {
        let vc  = UserDetailBuilder.viewController(user: userDetail)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logout() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
