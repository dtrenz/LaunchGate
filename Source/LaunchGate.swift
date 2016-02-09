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

  public var parser: LaunchGateParser

  let configurationFileURI: String
  var dialogManager: DialogManager

  // MARK: - Public API

  public init(uri: String) {
    configurationFileURI = uri
    parser = DefaultParser()
    dialogManager = DialogManager()
  }

  public func check() {
    let remoteFileManager = RemoteFileManager(remoteFileURIString: configurationFileURI)

    performCheck(remoteFileManager)
  }

  // MARK: - Internal API

  func performCheck(remoteFileManager: RemoteFileManager) {

    remoteFileManager.fetchRemoteFile { (jsonData) -> Void in
      if let config = self.parser.parse(jsonData) {
        self.displayDialogIfNecessary(config, dialogManager: DialogManager())
      }
    }

  }

  func displayDialogIfNecessary(config: LaunchGateConfiguration, dialogManager: DialogManager) {

    if let appVersion = currentAppVersion() {
      if let reqUpdate = config.requiredUpdate where shouldShowUpdateDialog(reqUpdate, appVersion: appVersion) {
        dialogManager.displayRequiredUpdateDialog(reqUpdate)
      } else if let optUpdate = config.optionalUpdate where shouldShowUpdateDialog(optUpdate, appVersion: appVersion) {
        dialogManager.displayOptionalUpdateDialog(optUpdate)
      } else if let alert = config.alert where shouldShowAlertDialog(alert) {
        dialogManager.displayAlertDialog(alert)
      }
    }

  }

  func shouldShowUpdateDialog(updateConfig: UpdateConfiguration, appVersion: String) -> Bool {
    return appVersion < updateConfig.version
  }

  func shouldShowAlertDialog(alertConfig: AlertConfiguration) -> Bool {
    return alertConfig.message.isEmpty == false
  }

  func currentAppVersion() -> String? {
    return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
  }

}
