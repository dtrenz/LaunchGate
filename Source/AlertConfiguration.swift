//
//  AlertConfiguration.swift
//  Pods
//
//  Created by Dan Trenz on 2/8/16.
//

import Foundation


public struct AlertConfiguration: Dialogable, Rememberable {

  let message: String
  let blocking: Bool

  init(message: String, blocking: Bool) {
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
