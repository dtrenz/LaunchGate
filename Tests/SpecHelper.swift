//
//  SpecHelper.swift
//  LaunchGate
//

import Foundation

class SpecHelper {
  
  enum Error: ErrorType {
    case BundleNotFound
    case FileNotFound
  }
  
  static func loadFixture(name: String) throws -> NSData {
    let bundle = NSBundle(forClass: SpecHelper.self)
    
    guard let path = bundle.pathForResource(name, ofType: nil) else {
      throw Error.FileNotFound
    }
    
    let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
    
    return data
  }
  
}
