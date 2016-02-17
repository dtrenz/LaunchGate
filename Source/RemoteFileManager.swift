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
    performRemoteFileRequest(NSURLSession.sharedSession(), url: remoteFileURL, responseHandler: callback)
  }

  func performRemoteFileRequest(session: NSURLSession, url: NSURL, responseHandler: (data: NSData) -> Void) {
    let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
      if let error = error {
        print("LaunchGate — Error: \(error.localizedDescription)")
      }

      guard let data = data else {
        print("LaunchGate — Error: Remote configuration file response was empty.")
        return
      }

      responseHandler(data: data)
    }

    task.resume()
  }

}
