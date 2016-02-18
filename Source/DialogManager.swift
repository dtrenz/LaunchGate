//
//  DialogManager.swift
//  Pods
//
//  Created by Dan Trenz on 2/5/16.
//
//

import Foundation


protocol Dialogable {
  var message: String { get }
}

class DialogManager {

  typealias RememberableDialogSubject = protocol<Dialogable, Rememberable>

  enum DialogType {
    case Alert(blocking: Bool)
    case OptionalUpdate(updateURL: NSURL)
    case RequiredUpdate(updateURL: NSURL)
  }

  func displayAlertDialog(alertConfig: RememberableDialogSubject, blocking: Bool) {
    let dialog = createAlertController(.Alert(blocking: blocking), message: alertConfig.message)

    displayAlertController(dialog) { () -> Void in
      if !blocking {
        Memory.remember(alertConfig)
      }
    }
  }

  func displayRequiredUpdateDialog(updateConfig: Dialogable, updateURL: NSURL) {
    let dialog = createAlertController(.RequiredUpdate(updateURL: updateURL), message: updateConfig.message)

    displayAlertController(dialog, completion: nil)
  }

  func displayOptionalUpdateDialog(updateConfig: RememberableDialogSubject, updateURL: NSURL) {
    let dialog = createAlertController(.OptionalUpdate(updateURL: updateURL), message: updateConfig.message)

    displayAlertController(dialog) { () -> Void in
      Memory.remember(updateConfig)
    }
  }

  // MARK: Custom Alert Controllers

  func createAlertController(type: DialogType, message: String) -> UIAlertController {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)

    switch type {
      case let .Alert(blocking):
        if !blocking {
          alertController.addAction(dismissActon())
        }

      case let .OptionalUpdate(updateURL):
        alertController.addAction(dismissActon())
        alertController.addAction(updateAction(updateURL))

      case let .RequiredUpdate(updateURL):
        alertController.addAction(updateAction(updateURL))
    }

    return alertController
  }

  func displayAlertController(alert: UIAlertController, completion: (() -> Void)?) {
    dispatch_async(dispatch_get_main_queue()) { [] in
      if let topViewController = self.topViewController() {
        topViewController.presentViewController(alert, animated: true) {
          if let completion = completion {
            completion()
          }
        }
      }
    }
  }

  func topViewController() -> UIViewController? {
    return UIApplication.sharedApplication().keyWindow?.rootViewController
  }

  // MARK: Custom Alert Actions

  private func dismissActon() -> UIAlertAction {
    return UIAlertAction(title: "Dismiss", style: .Default) { _ in }
  }

  private func updateAction(updateURL: NSURL) -> UIAlertAction {
    return UIAlertAction(title: "Update", style: .Default) { (action) -> Void in
      if UIApplication.sharedApplication().canOpenURL(updateURL) {
        dispatch_async(dispatch_get_main_queue()) { [] in
          UIApplication.sharedApplication().openURL(updateURL)
        }
      }
    }
  }

}
