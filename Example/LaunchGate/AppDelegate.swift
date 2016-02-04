//
//  AppDelegate.swift
//  LaunchGate
//
//  Created by git on 01/19/2016.
//  Copyright (c) 2016 git. All rights reserved.
//

import UIKit
import LaunchGate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  lazy var launchGate = LaunchGate(uri: "https://raw.githubusercontent.com/dtrenz/LaunchGate/develop/Example/Tests/Fixtures/config.json")

  func applicationDidBecomeActive(application: UIApplication) {
    launchGate.performCheck()
  }

}
