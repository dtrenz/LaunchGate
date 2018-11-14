//
//  AlertConfiguration.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/8/16.
//

import Foundation

public class AlertConfiguration: Decodable, Dialogable, Rememberable {

    let message: String
    let blocking: Bool

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
