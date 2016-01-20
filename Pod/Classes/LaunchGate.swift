//
//  LaunchGate.swift
//  Pods
//
//  Created by Dan Trenz on 1/19/16.
//
//

import Foundation


public class LaunchGate {
  
  public var uri: String {
    get {
      return remoteFileManager.remoteFileURI.URLString
    }
  }
  
  private let remoteFileManager: LaunchGateRemoteFileManager
  
  public init(uri: String) {
    remoteFileManager = LaunchGateRemoteFileManager(remoteFileURI: uri)
  }
  
}
