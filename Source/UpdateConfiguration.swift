//
//  UpdateConfiguration.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/8/16.
//
//

import Foundation

public struct UpdateConfiguration: Decodable, Dialogable, Rememberable {
    /// NOTE: 'version' name not the same; 'minimumVersion'
    let version: String
    let message: String

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
