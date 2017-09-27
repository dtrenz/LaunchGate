//
//  SpecHelper.swift
//  LaunchGate
//

import Foundation

class SpecHelper {
  
  enum SpecHelperError: Error {
    case bundleNotFound
    case fileNotFound
  }
  
  static func loadFixture(_ name: String) throws -> Data {
    let bundle = Bundle(for: SpecHelper.self)
    
    guard let path = bundle.path(forResource: name, ofType: nil) else {
      throw SpecHelperError.fileNotFound
    }
    
    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe)
    
    return data
  }
  
}
