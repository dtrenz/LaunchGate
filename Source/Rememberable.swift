//
//  Rememberable
//  LaunchGate
//
//  Created by Dan Trenz on 2/8/16.
//
//

import Foundation

protocol Rememberable {
  func rememberKey() -> String
  func rememberString() -> String
}

extension Rememberable {

  func isNotRemembered() -> Bool {
    !Memory.contains(self)
  }

}
