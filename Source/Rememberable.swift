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

  func remember() {
    NSUserDefaults.standardUserDefaults().setObject(rememberString(), forKey: rememberKey())
  }

  func isNotRemembered() -> Bool {
    let defaults =  NSUserDefaults.standardUserDefaults()

    if let alert = defaults.stringForKey(rememberKey()) where alert == rememberString() {
      return false
    }

    return true
  }

}
