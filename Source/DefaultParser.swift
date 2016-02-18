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

  private static func parseAlert(json: JSON) throws -> AlertConfiguration? {
    guard let message = json["message"] as? String else { throw Error.UnableToParseAlert }
    guard let blocking = json["blocking"] as? Bool else { throw Error.UnableToParseAlert }

    return AlertConfiguration(message: message, blocking: blocking)
  }

  private static func parseOptionalUpdate(json: JSON) throws -> UpdateConfiguration? {
    guard let version = json["optionalVersion"] as? String else { throw Error.UnableToParseOptionalUpdate }
    guard let message = json["message"] as? String else { throw Error.UnableToParseOptionalUpdate }

    return UpdateConfiguration(version: version, message: message)
  }

  private static func parseRequiredUpdate(json: JSON) throws -> UpdateConfiguration? {
    guard let version = json["minimumVersion"] as? String else { throw Error.UnableToParseRequiredUpdate }
    guard let message = json["message"] as? String else { throw Error.UnableToParseRequiredUpdate }

    return UpdateConfiguration(version: version, message: message)
  }

}
