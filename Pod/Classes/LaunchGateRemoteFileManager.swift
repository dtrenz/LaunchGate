//
//  LaunchGateRemoteFileManager.swift
//  Pods
//
//  Created by Dan Trenz on 1/20/16.
//
//

import Foundation


class LaunchGateRemoteFileManager {

  let remoteFileURI: NSURL?

  init(remoteFileURIString: String) {
    if let uri = NSURL(string: remoteFileURIString) {
      remoteFileURI = uri
    } else {
      remoteFileURI = nil
    }
  }

  func fetchRemoteFile(callback: (AnyObject?) -> Void) {
    if let uri = remoteFileURI,
           request = createRemoteFileRequest(uri) {
      performRemoteFileRequest(request, responseHandler: callback)
    }
  }

  func createRemoteFileRequest(uri: NSURL) -> NSURLRequest? {
    guard let uri = remoteFileURI else {
      return nil
    }

    return NSURLRequest(URL: uri)
  }

  func performRemoteFileRequest(request: NSURLRequest, responseHandler: (data: AnyObject?) -> Void) {
    NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
      if let error = error {
        print("LaunchGate — Error: \(error.localizedDescription)")
      }

      responseHandler(data: data)
    }
  }

}
