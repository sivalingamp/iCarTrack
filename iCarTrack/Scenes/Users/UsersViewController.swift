//
//  UsersViewController.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {
    
    fileprivate let viewModel: UsersViewModel
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    init(withViewModel viewModel: UsersViewModel) {
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
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        setupRx()
    }

}

// MARK: Setup
private extension UsersViewController {
    
    func setupRx() {
        
        let btnLogout = UIButton()
        btnLogout.setTitleColor(.white, for: .normal)
        btnLogout.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
        btnLogout.setTitle("Logout", for: .normal)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnLogout
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = UsersViewModel.Input(trigger: viewWillAppear,
                                         selectionTrigger: self.tableView.rx.itemSelected.asDriver(),
                                         logoutTrigger: btnLogout.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        output.error.drive(errorBinding).disposed(by: disposeBag)
        output.loading.drive(loading).disposed(by: disposeBag)
        output.logout.drive().disposed(by: disposeBag)
        output.selection.drive().disposed(by: disposeBag)
        output.data.drive(tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { tv, item, cell in
            cell.item = item
        }.disposed(by: disposeBag)
    }
    
    
    var loading: Binder<Bool> {
        return Binder(self, binding: { (vc, state) in
            //show/hide progress bar
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            Utils.displayAlert(title: "", message: error.localizedDescription, in: vc)
        })
    }
    
}

