//
//  ServerConfig.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/6/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation

public protocol ServerConfigType {
  var apiBaseUrlStr: String { get }
}

public func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
  return type(of: lhs) == type(of: rhs) && lhs.apiBaseUrlStr == rhs.apiBaseUrlStr
}

public struct ServerConfig: ServerConfigType {
  
  public let apiBaseUrlStr: String
  
  public static let production: ServerConfigType = ServerConfig(apiBaseUrlStr: Constants.API.ProductionUrlStr)
  
  public static let staging: ServerConfigType = ServerConfig(apiBaseUrlStr: Constants.API.StagingUrlStr)
  
  public static let local: ServerConfigType = ServerConfig(apiBaseUrlStr: Constants.API.LocalUrlStr)
  
  
  public init(apiBaseUrlStr: String) {
    self.apiBaseUrlStr = apiBaseUrlStr
  }
  
}
