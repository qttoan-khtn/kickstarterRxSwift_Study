//
//  TargetType.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/6/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import Foundation

/// Represents an HTTP task.
public enum Task {
  
  /// A basic request task.
  case request
  
  /// An upload task.
  case upload(UploadType)
  
  /// A download task.
  case download//(DownloadType)
}

public enum UploadType {
  /// Upload a file.
  case file(URL)
  
  /// Upload "multipart/form-data"
  case multipart([MultipartFormData])
}
