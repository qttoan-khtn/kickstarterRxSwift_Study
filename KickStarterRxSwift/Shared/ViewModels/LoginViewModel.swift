//
//  LoginViewModel.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/5/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation

public protocol LoginViewModelInputs {
    
    /// Call when the view did load
}

public protocol LoginViewModelOutputs {
    
}

public protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

public final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
    
    public var inputs: LoginViewModelInputs { return self }
    public var outputs: LoginViewModelOutputs { return self }
}
