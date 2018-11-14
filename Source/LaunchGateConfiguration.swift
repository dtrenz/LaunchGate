//
//  LaunchGateConfiguration
//  LaunchGate
//
//  Created by Dan Trenz on 2/2/16.
//
//

import Foundation

/// The configuration object that should be created as the result of parsing the remote configuration file.
public class LaunchGateConfiguration: Decodable {

  /// An `AlertConfiguration`, parsed from the configuration file.
  var alert: AlertConfiguration?

  /// An optional `UpdateConfiguration`, parsed from the configuration file.
  var optionalUpdate: UpdateConfiguration?

  /// A required `UpdateConfiguration`, parsed from the configuration file.
  var requiredUpdate: UpdateConfiguration?
    
    required public init(from decoder: Decoder) throws {
    let iosContainer = try decoder.container(keyedBy: IOSRootKey.self)
    //let ios = try iosContainer.nestedContainer(keyedBy: IOSRootKey.self, forKey: .ios)
    self.alert = try iosContainer.decode(AlertConfiguration.self, forKey: .alert)
    self.optionalUpdate = try iosContainer.decode(UpdateConfiguration.self, forKey: .optionalUpdate)
    self.requiredUpdate = try iosContainer.decode(UpdateConfiguration.self, forKey: .requiredUpdate)
    //let alert = try iosContainer.nestedContainer(keyedBy: IOSRootKey.self, forKey: .alert)
    //let optionalUpdate = try iosContainer.nestedContainer(keyedBy: IOSRootKey.self, forKey: .optionalUpdate)
    //let requiredUpdate = try iosContainer.nestedContainer(keyedBy: IOSRootKey.self, forKey: .requiredUpdate)
  }
  enum IOSRootKey: CodingKey {
    //case ios
    case alert
    case optionalUpdate
    case requiredUpdate
  }
//  enum ConfigCodingKeys: String, CodingKey {
//    case alert
//    case optionalUpdate
//    case requiredUpdate
//  }
}
