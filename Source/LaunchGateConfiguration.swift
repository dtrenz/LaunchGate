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

  public init(from decoder:Decoder) throws {
    let iosContainer = try decoder.container(keyedBy: IOSRootKey.self)
    let alert = try iosContainer.nestedContainer(keyedBy: IOSRootKey.self, forKey: .alert)
  }
  enum IOSRootKey: CodingKey {
    case ios
    case alert
    case optionalUpdate
    case requiredUpdate
  }
  enum ConfigCodingKeys: String, CodingKey {
    case alert
    case optionalUpdate
    case requiredUpdate
  }
}
