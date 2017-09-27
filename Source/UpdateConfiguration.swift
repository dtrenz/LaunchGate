//
//  UpdateConfiguration.swift
//  Pods
//
//  Created by Dan Trenz on 2/8/16.
//
//

import Foundation


public struct UpdateConfiguration: Dialogable, Rememberable {

  var version = ""
  var message = ""

  init?(version: String, message: String) {
    guard !version.isEmpty else { return nil }
    guard !message.isEmpty else { return nil }

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
