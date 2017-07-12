//
//  LoginRequest.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/12/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation
import Alamofire
import Argo

public struct LoginParam: Parameter {
 
  var username: String
  var password: String
  
  init(_ username: String, password: String) {
    self.username = username
    self.password = password
  }
  
  func toDictionary() -> [String : Any] {
    return ["_username" : self.username,
            "_password" : self.password]
  }
  
}

open class LoginRequest: Requestable {
  
  /// Type
  typealias Element = TokenObj
  
  /// Base
  var basePath: String { return Environment.serverConfig.apiBaseUrlStr }
  
  var endpoint: String { return "login_check" }
  
  var httpMethod: HTTPMethod { return .post }
  
  var param: Parameter? { return self._param }
  fileprivate var _param: LoginParam
  
  init(_ param: LoginParam) {
    self._param = param
  }
  
  func decode(data: Any) -> TokenObj? {
    guard let result = data as? [String: Any] else {
      return nil
    }
    
    return Argo.decode(result)
  }
  
}
