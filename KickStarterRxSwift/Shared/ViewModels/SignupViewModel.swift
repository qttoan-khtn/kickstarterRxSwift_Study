//
//  SignupViewModel.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/3/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation

public protocol SignupViewModelInputs {
 
}

public protocol SignupViewModelOutputs {
    
}

public protocol SignupViewModelType {
    var inputs: SignupViewModelInputs { get }
    var outputs: SignupViewModelOutputs { get }
}

public final class SignupViewModel: SignupViewModelType, SignupViewModelInputs, SignupViewModelOutputs {
    
    
  public var inputs: SignupViewModelInputs { return self }
  public var outputs: SignupViewModelOutputs { return self }
}
