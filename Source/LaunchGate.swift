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

  public var parser: LaunchGateParser!

  var configurationFileURL: NSURL!
  var updateURL: NSURL!
  var dialogManager: DialogManager!

  // MARK: - Public API

  public init?(configURI: String, appStoreURI: String) {
    guard let configURL = NSURL(string: configURI) else { return nil }
    guard let appStoreURL = NSURL(string: appStoreURI) else { return nil }

    configurationFileURL = configURL
    updateURL = appStoreURL
    parser = DefaultParser()
    dialogManager = DialogManager()
  }

  public func check() {
    performCheck(RemoteFileManager(remoteFileURL: configurationFileURL))
  }

  // MARK: - Internal API

  func performCheck(remoteFileManager: RemoteFileManager) {
    remoteFileManager.fetchRemoteFile { (jsonData) -> Void in
      if let config = self.parser.parse(jsonData) {
        self.displayDialogIfNecessary(config, dialogManager: self.dialogManager)
      }
    }
  }

  func displayDialogIfNecessary(config: LaunchGateConfiguration, dialogManager: DialogManager) {
    if let reqUpdate = config.requiredUpdate, appVersion = currentAppVersion() {
      if shouldShowRequiredUpdateDialog(reqUpdate, appVersion: appVersion) {
        dialogManager.displayRequiredUpdateDialog(reqUpdate, updateURL: updateURL)
      }
    } else if let optUpdate = config.optionalUpdate, appVersion = currentAppVersion() {
      if shouldShowOptionalUpdateDialog(optUpdate, appVersion: appVersion) {
        dialogManager.displayOptionalUpdateDialog(optUpdate, updateURL: updateURL)
      }
    } else if let alert = config.alert {
      if shouldShowAlertDialog(alert) {
        dialogManager.displayAlertDialog(alert, blocking: alert.blocking)
      }
    }
  }

  func shouldShowAlertDialog(alertConfig: AlertConfiguration) -> Bool {
    return alertConfig.blocking || alertConfig.isNotRemembered()
  }

  func shouldShowOptionalUpdateDialog(updateConfig: UpdateConfiguration, appVersion: String) -> Bool {
    guard updateConfig.isNotRemembered() else { return false }

    return appVersion < updateConfig.version
  }

  func shouldShowRequiredUpdateDialog(updateConfig: UpdateConfiguration, appVersion: String) -> Bool {
    return appVersion < updateConfig.version
  }

  func currentAppVersion() -> String? {
    return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
  }

}
