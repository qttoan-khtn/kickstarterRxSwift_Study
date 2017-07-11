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
  
  /// isValid => check input valid
  var isValid: Observable<Bool> { get }
  
}

public protocol LoginViewModelOutputs {
    
}

public protocol LoginViewModelType {
  var inputs: LoginViewModelInputs { get }
  var outputs: LoginViewModelOutputs { get }
}

public final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
  
  public var password: Variable<String?>  = Variable<String?>("")
  public var username: Variable<String?>  = Variable<String?>("")
  public var isValid : Observable<Bool>   = Observable.just(false)
  
  
  let disposeBag = DisposeBag()
  
  init() {
   
    username.asObservable().subscribe(onNext: { text in
      print(text!)
    }).addDisposableTo(disposeBag)
    
    isValid = Observable.combineLatest(username.asObservable() ,
                                       password.asObservable()) {
                                        (username,password) -> Bool in
      return true
    }
  }
  
  public var inputs: LoginViewModelInputs { return self }
  public var outputs: LoginViewModelOutputs { return self }
  
}
