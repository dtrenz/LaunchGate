//
//  DefaultParser.swift
//  LaunchGate
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
//    func parse(_ jsonData: Data) -> LaunchGateConfiguration? {
//        do {
//            let decoder = JSONDecoder()
//            let result = try decoder.decode(LaunchGateConfiguration.self, from: jsonData)
//            return result
//        } catch let error {
//            print("LaunchGate — Error: \(error)")
//        }
//        return nil
//    }
  func parse(_ jsonData: Data) -> LaunchGateConfiguration? {
    do {
        print("Parsing...")
        let jsonData = try JSONSerialization.jsonObject(with: jsonData, options: [])
      guard let json = jsonData as? JSON else { throw Error.unableToParseConfigurationObject }
      guard let config = json["ios"] else { throw Error.unableToParseConfigurationObject }

      var alert: AlertConfiguration?
      var optionalUpdate: UpdateConfiguration?
      var requiredUpdate: UpdateConfiguration?
        
      if let alertJSON = config["alert"] as? JSON {
        alert = try DefaultParser.parseAlert(alertJSON)
        print("Alert: \(alert!)")
      }

      if let optionalUpdateJSON = config["optionalUpdate"] as? JSON {
        optionalUpdate = try DefaultParser.parseOptionalUpdate(optionalUpdateJSON)
        print("Optional Update: \(optionalUpdate!)")
      }

      if let requiredUpdateJSON = config["requiredUpdate"] as? JSON {
        requiredUpdate = try DefaultParser.parseRequiredUpdate(requiredUpdateJSON)
        print("Required Update: \(requiredUpdate!)")
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
//   --- Experiments ---
//    private static func parseAlert(_ jsonData: Data) -> AlertConfiguration? {
//        do {
//            let decoder = JSONDecoder()
//            let result = try decoder.decode(AlertConfiguration.self, from: jsonData)
//            return result
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//    private static func parseOptionalUpdate(_ jsonData: Data) -> UpdateConfiguration? {
//        do {
//            let decoder = JSONDecoder()
//            let result = try decoder.decode(UpdateConfiguration.self, from: jsonData)
//            return result
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//    private static func parseRequiredUpdate(_ jsonData: Data) -> UpdateConfiguration? {
//        do {
//            let decoder = JSONDecoder()
//            let result = try decoder.decode(UpdateConfiguration.self, from: jsonData)
//            return result
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//  --- End of Experiments ---
  private static func parseAlert(_ json: JSON) throws -> AlertConfiguration? {
    guard let message = json["message"] as? String else { throw Error.unableToParseAlert }
    guard let blocking = json["blocking"] as? Bool else { throw Error.unableToParseAlert }

    return AlertConfiguration(message: message, blocking: blocking)
  }

  private static func parseOptionalUpdate(_ json: JSON) throws -> UpdateConfiguration? {
    guard let version = json["optionalVersion"] as? String else { throw Error.unableToParseOptionalUpdate }
    guard let message = json["message"] as? String else { throw Error.unableToParseOptionalUpdate }

    return UpdateConfiguration(version: version, message: message)
  }

  private static func parseRequiredUpdate(_ json: JSON) throws -> UpdateConfiguration? {
    guard let version = json["minimumVersion"] as? String else { throw Error.unableToParseRequiredUpdate }
    guard let message = json["message"] as? String else { throw Error.unableToParseRequiredUpdate }

    return UpdateConfiguration(version: version, message: message)
  }

}
