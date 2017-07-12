//
//  ErrorResponseObj.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/12/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct ErrorResponseObj {
  let statusCode: Int
  let message : String
}

extension ErrorResponseObj : Decodable {
  
  static func decode(_ json: JSON) -> Decoded<ErrorResponseObj> {
    return curry(ErrorResponseObj.init)
      <^> json <| "code"
      <*> json <| "message"
  }
  
}
