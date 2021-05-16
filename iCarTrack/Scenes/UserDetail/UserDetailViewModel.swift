//
//  UserDetailViewModel.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import RxCocoa
import Domain
import CoreLocation

class UserDetailViewModel: ViewModelType {
    
    private let router: UserDetailRouter
    private let userDetail:UserDetail
    
    init(userDetail:UserDetail, router:UserDetailRouter) {
        self.userDetail = userDetail
        self.router = router
    }
    
    // internal
    func transform(_ input: Input) -> Output {
        let cellData = input.trigger.map { [unowned self] _ in
            return CellData.cells(from: self.userDetail)
        }
        let location = Driver.just(self.userDetail).map { detail -> (name:String?, location:CLLocationCoordinate2D) in
            let lat = Double(detail.address?.geo?.lat ?? "0.0") ?? 0.0
            let long = Double(detail.address?.geo?.lng ?? "0.0") ?? 0.0
            return (name:detail.name, location:CLLocationCoordinate2D(latitude: lat, longitude: long))
        }
        return Output(data: cellData, location: location)
    }
    
}

extension UserDetailViewModel {
    
    // input
    struct Input {
        let trigger:Driver<Void>
    }
    // output
    struct Output {
        let data:Driver<[CellData]>
        let location:Driver<(name:String?, location:CLLocationCoordinate2D)>
    }
}


struct CellData {
    
    let title:String
    let text:String?
    
    static func cells(from user:UserDetail) ->[CellData] {
        var cellData = [CellData]()
        cellData.append(CellData(title: "Name", text: user.name ?? ""))
        cellData.append(CellData(title: "Address", text: user.address?.details()))
        cellData.append(CellData(title: "Email", text: user.email))
        cellData.append(CellData(title: "Phone", text: user.phone))
        cellData.append(CellData(title: "Website", text: user.website))
        cellData.append(CellData(title: "Company", text: user.company?.details()))
        return cellData
    }
}
