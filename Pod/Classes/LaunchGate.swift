//
//  LaunchGate.swift
//  Pods
//
//  Created by Dan Trenz on 1/19/16.
//
//

import Foundation


internal typealias LaunchGateError = protocol<ErrorType, CustomStringConvertible>

public class LaunchGate {

  internal var remoteFileManager: LaunchGateRemoteFileManager
  internal var parser: LaunchGateParser

  public init(uri: String) {
    remoteFileManager = LaunchGateRemoteFileManager(remoteFileURIString: uri)
    parser = LaunchGateDefaultParser()
  }

  public func performCheck() {
    remoteFileManager.fetchRemoteFile { (jsonData) -> Void in
      if let config = self.parser.parse(jsonData) {
        print(config)
      }
    }
  }

  public func setParser<T: LaunchGateParser>(parser: T) {
    self.parser = parser
  }

}
