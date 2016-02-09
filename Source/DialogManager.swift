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
  }

  func displayOptionalUpdateDialog(configObject: RememberableDialogSubject) {
    if configObject.isNotRemembered() {
      configObject.remember()
    }
  }

}
