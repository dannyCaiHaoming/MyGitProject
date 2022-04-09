//
//  SimpleValidationViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5



class SimpleValidationViewController : ViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!

    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!

    @IBOutlet weak var doSomethingOutlet: UIButton!

    
    
    
    
    let bag = DisposeBag()
    
    
    func setupUI() {
        
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValidOb: Observable<Bool> = usernameOutlet.rx.text.map { str in
            print("ch -- usernameValidOb")
            return str != nil && str!.count >= minimalUsernameLength
        }.share(replay: 1)
        let passwordValidOb: Observable<Bool> = passwordOutlet .rx.text.map { str in
            print("ch -- passwordValidOb")
            return str != nil && str!.count >= minimalPasswordLength
        }.share(replay: 1)
        let nextValidOb: Observable<Bool> = Observable.combineLatest(usernameValidOb, passwordValidOb).map { (op1,op2) in
            print("ch -- nextValidOb")
            return op1 && op2
        }.share(replay: 1)
        
        usernameValidOb.bind(to: self.usernameValidOutlet.rx.isHidden)
            .disposed(by: bag)
        usernameValidOb.bind(to: self.passwordOutlet.rx.isEnabled)
            .disposed(by: bag)
        
        passwordValidOb.bind(to: self.passwordValidOutlet.rx.isHidden)
            .disposed(by: bag)
        
        nextValidOb.bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: bag)
        
        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//
//        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
//        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
//
//        let usernameValid = usernameOutlet.rx.text.orEmpty
//            .map { $0.count >= minimalUsernameLength }
//            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
//
//        let passwordValid = passwordOutlet.rx.text.orEmpty
//            .map { $0.count >= minimalPasswordLength }
//            .share(replay: 1)
//
//        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
//            .share(replay: 1)
//
//        usernameValid
//            .bind(to: passwordOutlet.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//        usernameValid
//            .bind(to: usernameValidOutlet.rx.isHidden)
//            .disposed(by: disposeBag)
//
//        passwordValid
//            .bind(to: passwordValidOutlet.rx.isHidden)
//            .disposed(by: disposeBag)
//
//        everythingValid
//            .bind(to: doSomethingOutlet.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//        doSomethingOutlet.rx.tap
//            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
//            .disposed(by: disposeBag)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}
