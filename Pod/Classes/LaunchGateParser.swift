//
//  LaunchGateParser.swift
//  Pods
//
//  Created by Dan Trenz on 2/4/16.
//
//

import Foundation

public protocol LaunchGateParser {

  /**
   Parse the configuration file into a `LaunchGateRemoteConfiguration` object.

   - parameter jsonData: The configuration file JSON as NSData.

   - returns: The resulting `LaunchGateRemoteConfiguration` object,
   or `nil` if parsing fails for any reason (i.e. malformed JSON response).
   */
  func parse(jsonData: NSData) -> LaunchGateConfiguration?

}
