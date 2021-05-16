//
//  LoginViewController.swift
//  iCarTrack
//
//  Created by siva lingam on 13/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    fileprivate let viewModel: LoginViewModel
    fileprivate let router: LoginRouter
    fileprivate let disposeBag = DisposeBag()
    @IBOutlet weak var logoXConstrain: NSLayoutConstraint!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var remeberMeBtn: UIButton!
    
    private let country = PublishSubject<String>()
    
    init(withViewModel viewModel: LoginViewModel, router: LoginRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        animateLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
        self.countryBtn.setTitle("", for: .normal)
    }
}

// MARK: Setup
private extension LoginViewController {
    
    func animateLoginView() {
        logoXConstrain.constant = -200
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: {_ in
            self.loginStackView.isHidden = false
        }
    }
    
    func setupRx() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = LoginViewModel.Input(trigger: viewWillAppear,
                                         userName: userNameTextField.rx.text.orEmpty.asDriver(),
                                         password: passwordTextField.rx.text.orEmpty.asDriver(),
                                         country: country.asDriverOnErrorJustComplete(),
                                         countryTrigger: self.countryBtn.rx.tap.asDriver(),
                                         loginTrigger: loginBtn.rx.tap.asDriver(),
                                         rememberMeTrigger: remeberMeBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        output.canSubmit.drive(loginBtn.rx.isEnabled).disposed(by: disposeBag)
        output.proceed.drive().disposed(by: disposeBag)
        output.trigger.drive().disposed(by: disposeBag)
        output.rememberMe.drive(remeberMeBtn.rx.isSelected).disposed(by: disposeBag)
        output.error.drive(errorBinding).disposed(by: disposeBag)
        output.country.drive(countries).disposed(by: disposeBag)
        output.loading.drive(loading).disposed(by: disposeBag)
    }
    
    
    var remeberMe: Binder<Bool> {
        return Binder(self, binding: { (vc, state) in
            vc.remeberMeBtn.isSelected = state
        })
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
    
    var countries: Binder<[String]> {
        
        return Binder(self, binding: { (vc, countries) in
            let optionMenu = UIAlertController(title: nil, message: "Choose Country", preferredStyle: .actionSheet)
            for country in countries {
                let action =  UIAlertAction(title: country, style: .default) { action in
                    vc.countryBtn.setTitle(action.title, for: .normal)
                    vc.country.onNext(action.title ?? "")
                }
                optionMenu.addAction(action)
            }
            optionMenu.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            vc.present(optionMenu, animated: true, completion: nil)
        })
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
