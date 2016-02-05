//
//  LaunchGateSpecHelper.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class LaunchGateSpecHelper {
  
  enum Error: ErrorType {
    case BundleNotFound
    case FileNotFound
  }
  
  static func loadFixture(name: String) throws -> NSData {
    let bundle = NSBundle(forClass: LaunchGateSpecHelper.self)
    
    guard let path = bundle.pathForResource(name, ofType: nil) else {
      throw Error.FileNotFound
    }
    
    let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
    
    return data
  }
  
}
