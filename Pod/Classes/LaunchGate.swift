//
//  LaunchGate.swift
//  Pods
//
//  Created by Dan Trenz on 1/19/16.
//
//

import Foundation


typealias LaunchGateError = protocol<ErrorType, CustomStringConvertible>

public class LaunchGate {

  let configurationFileURI: String
  var parser: LaunchGateParser
  var dialogManager: LaunchGateDialogManager

  // MARK: - Public API

  public init(uri: String) {
    configurationFileURI = uri
    parser = LaunchGateDefaultParser()
    dialogManager = LaunchGateDialogManager()
  }

  public func check() {
    let remoteFileManager = LaunchGateRemoteFileManager(remoteFileURIString: configurationFileURI)

    performCheck(remoteFileManager)
  }

  public func setParser<T: LaunchGateParser>(parser: T) {
    self.parser = parser
  }

  // MARK: - Internal API

  func performCheck(remoteFileManager: LaunchGateRemoteFileManager) {

    remoteFileManager.fetchRemoteFile { (jsonData) -> Void in
      if let config = self.parser.parse(jsonData) {
        self.displayDialogIfNecessary(config, dialogManager: LaunchGateDialogManager())
      }
    }

  }

  func displayDialogIfNecessary(config: LaunchGateConfiguration, dialogManager: LaunchGateDialogManager) {

    if let appVersion = currentAppVersion() {
      if let reqUpdate = config.requiredUpdate where shouldShowUpdateDialog(reqUpdate, appVersion: appVersion) {
        dialogManager.displayRequiredUpdateDialog(reqUpdate.message)
      } else if let optUpdate = config.optionalUpdate where shouldShowUpdateDialog(optUpdate, appVersion: appVersion) {
        dialogManager.displayOptionalUpdateDialog(optUpdate.message)
      } else if let alert = config.alert where shouldShowAlertDialog(alert) {
        dialogManager.displayAlertDialog(alert.message)
      }
    }

  }

  func shouldShowUpdateDialog(updateConfig: LaunchGateUpdateConfiguration, appVersion: String) -> Bool {
    return appVersion < updateConfig.version
  }

  func shouldShowAlertDialog(alertConfig: LaunchGateAlertConfiguration) -> Bool {
    return alertConfig.message.isEmpty == false
  }

  func currentAppVersion() -> String? {
    return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
  }

}
