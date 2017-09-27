//
//  Memory.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/10/16.
//  Copyright © 2016 Dan Trenz. All rights reserved.
//

import Foundation


struct Memory {

  static var userPrefs: UserDefaults {
    return UserDefaults.standard
  }

  static func remember(_ item: Rememberable) {
    userPrefs.set(item.rememberString(), forKey: item.rememberKey())
  }

  static func forget(_ item: Rememberable) {
    userPrefs.removeObject(forKey: item.rememberKey())
  }

  static func contains(_ item: Rememberable) -> Bool {
    if let storedString = userPrefs.string(forKey: item.rememberKey()), storedString == item.rememberString() {
      return true
    }

    return false
  }

}
