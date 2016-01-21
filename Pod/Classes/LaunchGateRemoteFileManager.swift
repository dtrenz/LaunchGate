//
//  LaunchGateRemoteFileManager.swift
//  Pods
//
//  Created by Dan Trenz on 1/20/16.
//
//

import Foundation

import Alamofire


class LaunchGateRemoteFileManager {
  
  let remoteFileURI: URLStringConvertible
  
  init(remoteFileURI: URLStringConvertible) {
    self.remoteFileURI = remoteFileURI
  }
  
  func fetchRemoteFile(callback: (AnyObject?) -> Void) {
    if let request = createRemoteFileRequest(remoteFileURI) {
      performRemoteFileRequest(request, responseHandler: callback)
    }
  }
  
  func createRemoteFileRequest(uri: URLStringConvertible) -> Request? {
    return Alamofire.request(.GET, uri)
  }
  
  func performRemoteFileRequest(request: Request, responseHandler: (response: AnyObject?) -> Void) {
    request.responseJSON { response in
      responseHandler(response: response.result.value)
    }
  }
  
}
