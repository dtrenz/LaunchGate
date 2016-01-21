//
//  LaunchGate.swift
//  Pods
//
//  Created by Dan Trenz on 1/19/16.
//
//

import Foundation


public class LaunchGate {
  
<<<<<<< HEAD
  var remoteFileManager: LaunchGateRemoteFileManager
=======
  public var uri: String {
    get {
      return remoteFileManager.remoteFileURI.URLString
    }
  }
  
  private let remoteFileManager: LaunchGateRemoteFileManager
>>>>>>> develop
  
  public init(uri: String) {
    remoteFileManager = LaunchGateRemoteFileManager(remoteFileURI: uri)
  }
  
<<<<<<< HEAD
  public func performCheck() {
    remoteFileManager.fetchRemoteFile { (json) -> Void in
      print("JSON: \(json)")
    }
  }
  
=======
>>>>>>> develop
}
