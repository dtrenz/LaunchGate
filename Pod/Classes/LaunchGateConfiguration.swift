//
//  LaunchGateConfiguration
//  Pods
//
//  Created by Dan Trenz on 2/2/16.
//
//

import Foundation


public struct LaunchGateAlertConfiguration {
  let message: String
  let blocking: Bool

  init(message: String, blocking: Bool) {
    self.message = message
    self.blocking = blocking
  }
}

public struct LaunchGateUpdateConfiguration {
  let version: String
  let message: String

  init(version: String, message: String) {
    self.version = version
    self.message = message
  }
}

public struct LaunchGateConfiguration {

  var alert: LaunchGateAlertConfiguration?
  var optionalUpdate: LaunchGateUpdateConfiguration?
  var requiredUpdate: LaunchGateUpdateConfiguration?

}
