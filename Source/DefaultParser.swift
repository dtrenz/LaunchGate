//
//  DefaultParser.swift
//  Pods
//
//  Created by Dan Trenz on 2/4/16.
//
//

import Foundation

class DefaultParser: LaunchGateParser {

  typealias JSON = [String: AnyObject]

  enum Error: LaunchGateError {
    case unableToParseConfigurationObject
    case unableToParseAlert
    case unableToParseOptionalUpdate
    case unableToParseRequiredUpdate

    var description: String {
      switch self {
        case .unableToParseConfigurationObject:
          return "Unable to parse the configuration object (\"ios\") from JSON file."
        case .unableToParseAlert:
          return "Unable to parse the alert configuration from JSON file."
        case .unableToParseOptionalUpdate:
          return "Unable to parse the optional update configuration from JSON file."
        case .unableToParseRequiredUpdate:
          return "Unable to parse the required update configuration from JSON file."
      }
    }
  }

  func parse(_ jsonData: Data) -> LaunchGateConfiguration? {
    do {
        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! JSON

      guard let config = json["ios"] else { throw Error.unableToParseConfigurationObject }

      var alert: AlertConfiguration?
      var optionalUpdate: UpdateConfiguration?
      var requiredUpdate: UpdateConfiguration?

      if let alertJSON = config["alert"] as? JSON {
        alert = try DefaultParser.parseAlert(alertJSON)
      }

      if let optionalUpdateJSON = config["optionalUpdate"] as? JSON {
        optionalUpdate = try DefaultParser.parseOptionalUpdate(optionalUpdateJSON)
      }

      if let requiredUpdateJSON = config["requiredUpdate"] as? JSON {
        requiredUpdate = try DefaultParser.parseRequiredUpdate(requiredUpdateJSON)
      }

      return LaunchGateConfiguration(alert: alert, optionalUpdate: optionalUpdate, requiredUpdate: requiredUpdate)
    } catch let error as DefaultParser.Error {
      print("LaunchGate — Error: \(error)")
    } catch let error as NSError {
      print("LaunchGate — Error: \(error.localizedDescription)")

      if let recoverySuggestion = error.localizedRecoverySuggestion {
        print(recoverySuggestion)
      }
    }

    return nil
  }

  fileprivate static func parseAlert(_ json: JSON) throws -> AlertConfiguration? {
    guard let message = json["message"] as? String else { throw Error.unableToParseAlert }
    guard let blocking = json["blocking"] as? Bool else { throw Error.unableToParseAlert }

    return AlertConfiguration(message: message, blocking: blocking)
  }

  fileprivate static func parseOptionalUpdate(_ json: JSON) throws -> UpdateConfiguration? {
    guard let version = json["optionalVersion"] as? String else { throw Error.unableToParseOptionalUpdate }
    guard let message = json["message"] as? String else { throw Error.unableToParseOptionalUpdate }

    return UpdateConfiguration(version: version, message: message)
  }

  fileprivate static func parseRequiredUpdate(_ json: JSON) throws -> UpdateConfiguration? {
    guard let version = json["minimumVersion"] as? String else { throw Error.unableToParseRequiredUpdate }
    guard let message = json["message"] as? String else { throw Error.unableToParseRequiredUpdate }

    return UpdateConfiguration(version: version, message: message)
  }

}
