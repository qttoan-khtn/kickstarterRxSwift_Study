//
//  SearchRequest.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/5/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation
import Alamofire

public struct SearchParam: Parameter {
  
  func toDictionary() -> [String : Any] {
    return ["key":"AIzaSyA9pgauJF2iAGwkJ1cgkb5w5Z2iA6WtucY",
            "part":"id,snippet"]
  }
}

open class SearchRequest: Requestable {
  
  // Type
  typealias Element = [SearchObj]
  
  // Base
  var basePath: String { return "https://www.googleapis.com/youtube/v3" }
  
  // Endpoint
  var endpoint: String { return "/search" }
  
  // HTTP
  var httpMethod: HTTPMethod { return .get }
  
  // Param
  var param: Parameter? { return self._param }
  fileprivate var _param: SearchParam
  
  // Task
  var task: Task {
    return .upload(.multipart([MultipartFormData(provider: .data(Data(count: 0)), name: "file", fileName: "name",
                                                 mimeType: "image/jpeg")]))
  }
  
  // MARK: - Init
  init(_ param: SearchParam) {
    self._param = param
  }
  
  // MARK: - Decode
  func decode(data: Any) -> [SearchObj]? {
    guard let result = data as? [String: Any] else {
      return []
    }
    guard let places = result["results"] as? [[String: Any]] else {
      return []
    }
    return []//Mapper<SearchObj>().mapArray(JSONArray: places)
  }
}
