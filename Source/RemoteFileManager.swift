//
//  RemoteFileManager.swift
//  LaunchGate
//
//  Created by Dan Trenz on 1/20/16.
//
//

import Foundation

protocol RemoteFileManagerDelegate: class {
    func errorWithRemoteFileHandler()
}

class RemoteFileManager {

    let remoteFileURL: URL

    weak var delegate: RemoteFileManagerDelegate?

    init(remoteFileURL: URL, andDelegate delegate: RemoteFileManagerDelegate? = nil) {
        print("✡️ [RemoteFileManager] remoteFileURL : \(remoteFileURL) ")
        self.remoteFileURL = remoteFileURL
        self.delegate = delegate
    }

    func fetchRemoteFile(_ callback: @escaping (Data) -> Void) {
        performRemoteFileRequest(URLSession.shared, url: remoteFileURL, responseHandler: callback)
    }

    func performRemoteFileRequest(_ session: URLSession, url: URL, responseHandler: @escaping (_ data: Data) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("🔽 LaunchGate — Error: \(error.localizedDescription)")
                self.delegate?.errorWithRemoteFileHandler()
            }
            guard response != nil else {
                print("🔽 LaunchGate - Error because there is no response")
                self.delegate?.errorWithRemoteFileHandler()
                return
            }
            guard let data = data else {
                print("🔽 LaunchGate — Error: Remote configuration file response was empty.")
                self.delegate?.errorWithRemoteFileHandler()
                return
            }
            responseHandler(data)
        }
        task.resume()
    }

}
