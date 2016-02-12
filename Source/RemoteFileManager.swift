//
//  RemoteFileManager.swift
//  Pods
//
//  Created by Dan Trenz on 1/20/16.
//
//

import Foundation


class RemoteFileManager {

  let remoteFileURL: NSURL

  init(remoteFileURL: NSURL) {
    self.remoteFileURL = remoteFileURL
  }

  func fetchRemoteFile(callback: (NSData) -> Void) {
    let request = NSURLRequest(URL: remoteFileURL)

    performRemoteFileRequest(request, responseHandler: callback)
  }

  func performRemoteFileRequest(request: NSURLRequest, responseHandler: (data: NSData) -> Void) {
    let session = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
      if let error = error {
        print("LaunchGate — Error: \(error.localizedDescription)")
      }

      guard let data = data else {
        print("LaunchGate — Error: Remote configuration file response was empty.")
        return
      }

      responseHandler(data: data)
    }

    session.resume()
  }

}
