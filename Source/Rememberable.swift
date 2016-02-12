//
//  Rememberable
//  Pods
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
    return !Memory.contains(self)
  }

}
