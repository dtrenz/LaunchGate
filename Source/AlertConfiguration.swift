//
//  AlertConfiguration.swift
//  Pods
//
//  Created by Dan Trenz on 2/8/16.
//

import Foundation


public struct AlertConfiguration: Dialogable, Rememberable {

  var message = ""
  var blocking = false

  init?(message: String, blocking: Bool) {
    guard !message.isEmpty else { return nil }

    self.message = message
    self.blocking = blocking
  }

  // MARK: Rememberable Protocol Methods

  func rememberKey() -> String {
    return "LAST_ALERT"
  }

  func rememberString() -> String {
    return self.message
  }

}
