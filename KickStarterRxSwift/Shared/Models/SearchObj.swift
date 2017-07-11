//
//  SearchObj.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/5/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct SearchObj {
  let id: String
}

extension SearchObj: Decodable {
  static func decode(_ json: JSON) -> Decoded<SearchObj> {
    return curry(SearchObj.init)
      <^> json <| "id"
  }
}

