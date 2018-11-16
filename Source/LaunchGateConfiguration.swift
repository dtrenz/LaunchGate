//
//  LaunchGateConfiguration
//  LaunchGate
//
//  Created by Dan Trenz on 2/2/16.
//
//

import Foundation

/// The configuration object that should be created as the result of parsing the remote configuration file.
public struct LaunchGateConfiguration: Decodable {

  /// An `AlertConfiguration`, parsed from the configuration file.
  var alert: AlertConfiguration?

  /// An optional `UpdateConfiguration`, parsed from the configuration file.
  var optionalUpdate: UpdateConfiguration?

  /// A required `UpdateConfiguration`, parsed from the configuration file.
  var requiredUpdate: UpdateConfiguration?

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: IOSCodingKeys.self)
    let iosContainer = try container.nestedContainer(keyedBy: IOSCodingKeys.self, forKey: .ios)
    alert = try iosContainer.decodeIfPresent(AlertConfiguration.self, forKey: .alert)
    optionalUpdate = try iosContainer.decodeIfPresent(UpdateConfiguration.self, forKey: .optionalUpdate)
    requiredUpdate = try iosContainer.decodeIfPresent(UpdateConfiguration.self, forKey: .requiredUpdate)
  }
  enum IOSCodingKeys: String, CodingKey {
    case ios
    case alert
    case optionalUpdate
    case requiredUpdate
  }
}
