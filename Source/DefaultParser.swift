//
//  DefaultParser.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/4/16.
//
//

import Foundation

class DefaultParser: LaunchGateParser {

    func parse(_ jsonData: Data) -> LaunchGateConfiguration? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(LaunchGateConfiguration.self, from: jsonData)
            return result
        } catch let error {
            print("LaunchGate — Error: \(error)")
        }
        return nil
    }
}
