//
//  DialogManager.swift
//  LaunchGate
//
//  Created by Dan Trenz on 2/5/16.
//
//

import Foundation

public protocol DialogManagerDelegate: class {
    func didDismissAlertView()
}

// Localization of strings

protocol Dialogable {
    var message: String { get }
}

class DialogManager {

    typealias RememberableDialogSubject = Dialogable & Rememberable

    enum DialogType {
        case alert(blocking: Bool)
        case optionalUpdate(updateURL: URL)
        case requiredUpdate(updateURL: URL)
    }

    var stringHandler: StringHandler?
    weak var delegate: DialogManagerDelegate?

    init(withStringHandler stringHandler: StringHandler? = nil, andDelegate delegate: DialogManagerDelegate? = nil) {
        self.stringHandler = stringHandler
        self.delegate = delegate
    }

    func displayAlertDialog(_ alertConfig: RememberableDialogSubject, blocking: Bool) {
        let dialog = createAlertController(.alert(blocking: blocking),
                                           message: stringHandler?.alertMessage ?? alertConfig.message)

        displayAlertController(dialog) { () -> Void in
            if !blocking {
                Memory.remember(alertConfig)
            }
        }
    }

    func displayRequiredUpdateDialog(_ updateConfig: Dialogable, updateURL: URL) {
        let dialog = createAlertController(.requiredUpdate(updateURL: updateURL),
                                           message: stringHandler?.requiredUpdateMessage ?? updateConfig.message)

        displayAlertController(dialog, completion: nil)
    }

    func displayOptionalUpdateDialog(_ updateConfig: RememberableDialogSubject, updateURL: URL) {
        let dialog = createAlertController(.optionalUpdate(updateURL: updateURL),
                                           message: stringHandler?.optionalUpdateMessage ?? updateConfig.message)

        displayAlertController(dialog) { () -> Void in
            Memory.remember(updateConfig)
        }
    }

    // MARK: Custom Alert Controllers

    func createAlertController(_ type: DialogType, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        switch type {
        case let .alert(blocking):
            if !blocking {
                alertController.addAction(dismissActon())
            }

        case let .optionalUpdate(updateURL):
            alertController.addAction(dismissActon())
            alertController.addAction(updateAction(updateURL))

        case let .requiredUpdate(updateURL):
            alertController.addAction(updateAction(updateURL))
        }

        return alertController
    }

    func displayAlertController(_ alert: UIAlertController, completion: (() -> Void)?) {
        DispatchQueue.main.async { [] in
            if let topViewController = self.topViewController() {
                topViewController.present(alert, animated: true) {
                    if let completion = completion {
                        completion()
                    }
                }
            }
        }
    }

    func topViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    // MARK: Custom Alert Actions

    private func dismissActon() -> UIAlertAction {
        return UIAlertAction(
            title: NSLocalizedString(stringHandler?.dismissTitle ?? "Dismiss", comment: "Button title for dismissing the update AlertView"),
            style: .default) { _ in
                self.delegate?.didDismissAlertView()
        }
    }

    private func updateAction(_ updateURL: URL) -> UIAlertAction {
        return UIAlertAction(
            title: NSLocalizedString(stringHandler?.downloadTitle ?? "Update", comment: "Button title for accepting the update AlertView"),
            style: .default) { (_) -> Void in
                if UIApplication.shared.canOpenURL(updateURL) {
                    DispatchQueue.main.async { [] in
                        UIApplication.shared.openURL(updateURL)
                    }
                }
        }
    }

}
