//
//  TokenObj.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/12/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct TokenObj {
  let token : String
}

extension TokenObj : Decodable {
  
  static func decode(_ json: JSON) -> Decoded<TokenObj> {
    return curry(TokenObj.init)
      <^> json <| "token"
  }
  
}
