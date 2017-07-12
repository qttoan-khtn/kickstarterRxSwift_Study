//
//  LoginViewModel.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/5/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol LoginViewModelInputs {
    
  /// username
  var username: Variable<String?> { get }
  
  /// password
  var password: Variable<String?> { get }
  
  /// button tap
  var buttonPressed: PublishSubject<Void> { get }
}

public protocol LoginViewModelOutputs {
  /// isValid => check input valid
  var isValid: Observable<Bool> { get }
}

public protocol LoginViewModelType {
  var inputs: LoginViewModelInputs { get }
  var outputs: LoginViewModelOutputs { get }
}

public final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
  
  public var password: Variable<String?>  = Variable<String?>("")
  public var username: Variable<String?>  = Variable<String?>("")
  public var isValid : Observable<Bool>   = Observable.just(false)
  public var buttonPressed: PublishSubject<Void> = PublishSubject<Void>()
  
  
  let disposeBag = DisposeBag()
  
  init() {
    
    isValid = Observable.combineLatest(username.asObservable() ,
                                       password.asObservable()) {
                                        (username,password) -> Bool in
      return true
    }
    
   
    buttonPressed.subscribe(onNext: {[unowned self] _ in
      let loginParam = LoginParam("thuc.pham@sutrixsolutions.com", password: "sutrix123")
      LoginRequest(loginParam)
        .toObservable()
        .subscribe(onNext: { token in
          print(token)
        }, onError: { error in
          print(error.localizedDescription)
        }).addDisposableTo(self.disposeBag)
    }).addDisposableTo(disposeBag)
  }
  
  public var inputs: LoginViewModelInputs { return self }
  public var outputs: LoginViewModelOutputs { return self }
  
}
