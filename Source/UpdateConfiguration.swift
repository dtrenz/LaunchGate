//
//  UpdateConfiguration.swift
//  Pods
//
//  Created by Dan Trenz on 2/8/16.
//
//

import Foundation


public struct UpdateConfiguration: Dialogable, Rememberable {

  let version: String
  let message: String

  init(version: String, message: String) {
    self.version = version
    self.message = message
  }

  // MARK: Rememberable Protocol Methods

  func rememberKey() -> String {
    return "OPTIONAL_UPDATE"
  }

  func rememberString() -> String {
    return self.version
  }

}
