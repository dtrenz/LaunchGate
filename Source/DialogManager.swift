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
    case OptionalUpdate
    case RequiredUpdate
  }

  func displayAlertDialog(alertConfig: RememberableDialogSubject, blocking: Bool) {
    let dialog = createAlertController(.Alert(blocking: blocking), message: alertConfig.message, updateURL: nil)

    dispatch_async(dispatch_get_main_queue()) { [] in
      if let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        topViewController.presentViewController(dialog, animated: true) {
          if !blocking {
            Memory.remember(alertConfig)
          }
        }
      }
    }
  }

  func displayRequiredUpdateDialog(updateConfig: Dialogable, updateURL: NSURL) {
    let dialog = createAlertController(.RequiredUpdate, message: updateConfig.message, updateURL: updateURL)

    dispatch_async(dispatch_get_main_queue()) { [] in
      if let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        topViewController.presentViewController(dialog, animated: true, completion: nil)
      }
    }
  }

  func displayOptionalUpdateDialog(updateConfig: RememberableDialogSubject, updateURL: NSURL) {
    let dialog = createAlertController(.OptionalUpdate, message: updateConfig.message, updateURL: updateURL)

    dispatch_async(dispatch_get_main_queue()) { [] in
      if let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        topViewController.presentViewController(dialog, animated: true) {
          Memory.remember(updateConfig)
        }
      }
    }
  }

  // MARK: - Private Methods

  // MARK: Custom Alert Controllers

  private func createAlertController(type: DialogType, message: String, updateURL: NSURL?) -> UIAlertController {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)

    switch type {
      case let .Alert(blocking):
        if !blocking {
          alertController.addAction(dismissActon())
        }

      case .OptionalUpdate:
        alertController.addAction(dismissActon())

        if let updateURL = updateURL {
          alertController.addAction(updateAction(updateURL))
        }

      case .RequiredUpdate:
        if let updateURL = updateURL {
          alertController.addAction(updateAction(updateURL))
        }
    }

    return alertController
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
