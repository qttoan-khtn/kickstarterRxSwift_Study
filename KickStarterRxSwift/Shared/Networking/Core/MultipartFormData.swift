//
//  MultipartFormData.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/6/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation

/// Represents "multipart/form-data" for an upload.
public struct MultipartFormData {
 
  /// Method to provide the form data.
  public enum FormDataProvider {
    case data(Foundation.Data)
    case file(URL)
    case stream(InputStream, UInt64)
  }
  
  /// Initialize a new `MultipartFormData`.
  public init(provider: FormDataProvider, name: String, fileName: String? = nil, mimeType: String? = nil) {
    self.provider = provider
    self.name = name
    self.fileName = fileName
    self.mimeType = mimeType
  }
  
  /// The method being used for providing form data.
  public let provider: FormDataProvider
  
  /// The name
  public let name: String
  
  /// The file name
  public let fileName: String?
  
  /// The MINE type
  public let mimeType: String?
}
