//
//  LaunchGate.swift
//  Pods
//
//  Created by Dan Trenz on 1/19/16.
//
//

import Foundation


public class LaunchGate {

  var remoteFileManager: LaunchGateRemoteFileManager

  public init(uri: String) {
    remoteFileManager = LaunchGateRemoteFileManager(remoteFileURI: uri)
  }

  public func performCheck() {
    remoteFileManager.fetchRemoteFile { (json) -> Void in
      print("JSON: \(json)")
    }
  }

}
