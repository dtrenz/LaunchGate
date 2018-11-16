//
//  RemoteFileManager.swift
//  LaunchGate
//
//  Created by Dan Trenz on 1/20/16.
//
//

import Foundation

class RemoteFileManager {

  let remoteFileURL: URL

  init(remoteFileURL: URL) {
    self.remoteFileURL = remoteFileURL
  }

  func fetchRemoteFile(_ callback: @escaping (Data) -> Void) {
    performRemoteFileRequest(URLSession.shared, url: remoteFileURL, responseHandler: callback)
  }

  func performRemoteFileRequest(_ session: URLSession, url: URL, responseHandler: @escaping (_ data: Data) -> Void) {
    let task = session.dataTask(with: url) { data, response, error in
      if let error = error {
        print("LaunchGate — Error2: \(error.localizedDescription)")
      }
      guard response != nil else {
        print("LaunchGate - Error because there is no response")
        return
      }
      guard let data = data else {
        print("LaunchGate — Error: Remote configuration file response was empty.")
        return
      }

      responseHandler(data)
    }

    task.resume()
  }

}
