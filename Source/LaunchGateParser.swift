//
//  LaunchGateParser.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/4/16.
//
//

import Foundation

/// Protocol to which any configuration parser must conform.
public protocol LaunchGateParser {

  /**
   Parse the configuration file into a `LaunchGateRemoteConfiguration` object.

   - Parameter jsonData: The configuration file JSON as Data.

   - Returns: The resulting `LaunchGateRemoteConfiguration` object,
   or `nil` if parsing fails for any reason (i.e. malformed JSON response).
   */
  func parse(_ jsonData: Data) -> LaunchGateConfiguration?

}
