//
//  UpdateConfiguration.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/8/16.
//
//

import Foundation

public struct UpdateConfiguration: Decodable, Dialogable, Rememberable {
    var version: String
    var message: String

  init?(version: String, message: String) {
    guard !version.isEmpty else { return nil }
    guard !message.isEmpty else { return nil }

    self.version = version
    self.message = message
  }
  public init(from decoder: Decoder) throws {
        let optionalKeyedContainer = try? decoder.container(keyedBy: OptionalCodingKeys.self)
        let requiredKeyedContainer = try? decoder.container(keyedBy: RequiredCodingKeys.self)
        version = try optionalKeyedContainer!.decode(String.self, forKey: .version)
        message = try optionalKeyedContainer!.decode(String.self, forKey: .message)
        version = try requiredKeyedContainer!.decode(String.self, forKey: .version)
        message = try requiredKeyedContainer!.decode(String.self, forKey: .message)
    }
    enum OptionalCodingKeys: String, CodingKey {
        case version = "optionalVersion"
        case message
    }
    enum RequiredCodingKeys: String, CodingKey {
        case version = "minimumVersion"
        case message
    }

  // MARK: Rememberable Protocol Methods

  func rememberKey() -> String {
    return "OPTIONAL_UPDATE"
  }

  func rememberString() -> String {
    return self.version
  }

}
