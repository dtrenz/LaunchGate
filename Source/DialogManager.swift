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

  func displayAlertDialog(configObject: RememberableDialogSubject) {
    if configObject.isNotRemembered() {
      configObject.remember()
    }
  }

  func displayRequiredUpdateDialog(configObject: Dialogable) {

    if let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
      let dialog = UIAlertController(title: nil, message: configObject.message, preferredStyle: .Alert)

      let updateAction = UIAlertAction(title: "Update", style: .Default) { (action) -> Void in
        if let appStoreURL = NSURL(string: "itms-apps://itunes.apple.com/us/app/wikipedia-mobile/id324715238") {

          if UIApplication.sharedApplication().canOpenURL(appStoreURL) {
            dispatch_async(dispatch_get_main_queue()) { [] in
                UIApplication.sharedApplication().openURL(appStoreURL)
            }
          }
        }
      }

      dialog.addAction(updateAction)
      
      dispatch_async(dispatch_get_main_queue()) { [] in
        topViewController.presentViewController(dialog, animated: true, completion: nil)
      }
    }
  }

  func displayOptionalUpdateDialog(configObject: RememberableDialogSubject) {
    if configObject.isNotRemembered() {
      configObject.remember()
    }
  }

}
