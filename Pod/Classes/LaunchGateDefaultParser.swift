//
//  LaunchGateDefaultParser.swift
//  Pods
//
//  Created by Dan Trenz on 2/4/16.
//
//

import Foundation

class LaunchGateDefaultParser: LaunchGateParser {

  typealias JSON = [String: AnyObject]

  enum Error: LaunchGateError {
    case UnableToParseConfigurationObject
    case UnableToParseAlert
    case UnableToParseOptionalUpdate
    case UnableToParseRequiredUpdate

    var description: String {
      switch self {
        case UnableToParseConfigurationObject:
          return "Unable to parse the configuration object (\"ios\") from JSON file."
        case UnableToParseAlert:
          return "Unable to parse the alert configuration from JSON file."
        case UnableToParseOptionalUpdate:
          return "Unable to parse the optional update configuration from JSON file."
        case UnableToParseRequiredUpdate:
          return "Unable to parse the required update configuration from JSON file."
      }
    }
  }

  func parse(jsonData: NSData) -> LaunchGateConfiguration? {
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])

      guard let config = json["ios"] as? JSON else { throw Error.UnableToParseConfigurationObject }

      let alert = try LaunchGateDefaultParser.parseAlert(config)
      let optionalUpdate = try LaunchGateDefaultParser.parseOptionalUpdate(config)
      let requiredUpdate = try LaunchGateDefaultParser.parseRequiredUpdate(config)

      return LaunchGateConfiguration(alert: alert, optionalUpdate: optionalUpdate, requiredUpdate: requiredUpdate)
    } catch let error as LaunchGateDefaultParser.Error {
      print("LaunchGate — Error: \(error)")
    } catch let error as NSError {
      print("LaunchGate — Error: \(error.localizedDescription)")

      if let recoverySuggestion = error.localizedRecoverySuggestion {
        print(recoverySuggestion)
      }
    }

    return nil
  }

  private static func parseAlert(json: JSON) throws -> LaunchGateAlertConfiguration {
    guard let alertObject = json["alert"] as? JSON else { throw Error.UnableToParseAlert }
    guard let message = alertObject["message"] as? String else { throw Error.UnableToParseAlert }
    guard let blocking = alertObject["blocking"] as? Bool else { throw Error.UnableToParseAlert }

    return LaunchGateAlertConfiguration(message: message, blocking: blocking)
  }

  private static func parseOptionalUpdate(json: JSON) throws -> LaunchGateUpdateConfiguration {
    guard let updateObject = json["optionalUpdate"] as? JSON else { throw Error.UnableToParseOptionalUpdate }
    guard let version = updateObject["optionalVersion"] as? String else { throw Error.UnableToParseOptionalUpdate }
    guard let message = updateObject["message"] as? String else { throw Error.UnableToParseOptionalUpdate }

    return LaunchGateUpdateConfiguration(version: version, message: message)
  }

  private static func parseRequiredUpdate(json: JSON) throws -> LaunchGateUpdateConfiguration {
    guard let updateObject = json["requiredUpdate"] as? JSON else { throw Error.UnableToParseRequiredUpdate }
    guard let version = updateObject["minimumVersion"] as? String else { throw Error.UnableToParseRequiredUpdate }
    guard let message = updateObject["message"] as? String else { throw Error.UnableToParseRequiredUpdate }

    return LaunchGateUpdateConfiguration(version: version, message: message)
  }

}
