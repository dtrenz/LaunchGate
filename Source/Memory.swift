//
//  Memory.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/10/16.
//  Copyright © 2016 Dan Trenz. All rights reserved.
//

import Foundation


struct Memory {

  static var userPrefs: NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }

  static func remember(item: Rememberable) {
    userPrefs.setObject(item.rememberString(), forKey: item.rememberKey())
  }

  static func forget(item: Rememberable) {
    userPrefs.removeObjectForKey(item.rememberKey())
  }

  static func contains(item: Rememberable) -> Bool {
    if let storedString = userPrefs.stringForKey(item.rememberKey()) where storedString == item.rememberString() {
      return true
    }

    return false
  }

}
