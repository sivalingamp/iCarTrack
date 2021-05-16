//
//  UserDetailViewController.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import MapKit

class UserDetailViewController: UIViewController {
    
    fileprivate let viewModel: UserDetailViewModel
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    init(withViewModel viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "UserDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailTableViewCell")
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Setup
private extension UserDetailViewController {
    
    func setupRx() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = UserDetailViewModel.Input(trigger: viewWillAppear)
        
        let output = viewModel.transform(input)
        output.data.drive(tableView.rx.items(cellIdentifier: "UserDetailTableViewCell", cellType: UserDetailTableViewCell.self)) { tv, item, cell in
            cell.item = item
        }.disposed(by: disposeBag)
        output.location.drive(location).disposed(by: disposeBag)
    }
    
    
    var location: Binder<(name:String?, location:CLLocationCoordinate2D)> {
        return Binder(self, binding: { (vc, data) in
            vc.centerMapOnLocation(title: data.name, location: data.location)
        })
    }
    
    func centerMapOnLocation(title:String?, location: CLLocationCoordinate2D) {
       let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
       DispatchQueue.main.async {
           self.mapView.setRegion(region, animated: true)
           let annotation = MKPointAnnotation()
           annotation.title = title
           annotation.coordinate = location
           self.mapView.addAnnotation(annotation)
           self.title = title
       }
   }

}

