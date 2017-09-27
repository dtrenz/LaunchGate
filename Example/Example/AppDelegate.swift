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

  lazy var launchGate: LaunchGate? = {
    let launchGate = LaunchGate(
      configURI: "https://raw.githubusercontent.com/dtrenz/LaunchGate/master/Example/Example/example.json",
      appStoreURI: "itms-apps://itunes.apple.com/us/app/wikipedia-mobile/id324715238"
    )
    
    // If you need to use a custom config file structure,
    // you can create a default parser that conforms to LaunchGateParser:
    //
    // launchGate?.parser = MyCustomParser()
    
    return launchGate
  }()
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    launchGate?.check()
  }

}
