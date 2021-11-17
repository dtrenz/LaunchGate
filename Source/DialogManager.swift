import Foundation

#if os(iOS)
import UIKit
#endif

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

    func displayAlertDialog(_ alertConfig: RememberableDialogSubject, blocking: Bool) {
#if os(iOS)
        let dialog = createAlertController(.alert(blocking: blocking), message: alertConfig.message)

        displayAlertController(dialog) { () -> Void in
            guard !blocking else { return }

            Memory.remember(alertConfig)
        }
#endif
    }

    func displayRequiredUpdateDialog(_ updateConfig: Dialogable, updateURL: URL) {
#if os(iOS)
        let dialog = createAlertController(.requiredUpdate(updateURL: updateURL), message: updateConfig.message)

        displayAlertController(dialog, completion: nil)
#endif
    }

    func displayOptionalUpdateDialog(_ updateConfig: RememberableDialogSubject, updateURL: URL) {
#if os(iOS)
        let dialog = createAlertController(.optionalUpdate(updateURL: updateURL), message: updateConfig.message)

        displayAlertController(dialog) { () -> Void in
            Memory.remember(updateConfig)
        }
#endif
    }

    // MARK: Custom Alert Controllers

#if os(iOS)
    func createAlertController(_ type: DialogType, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        switch type {
        case .alert(let blocking):
            if !blocking {
                alertController.addAction(dismissActon())
            }

        case .optionalUpdate(let updateURL):
            alertController.addAction(dismissActon())
            alertController.addAction(updateAction(updateURL))

        case .requiredUpdate(let updateURL):
            alertController.addAction(updateAction(updateURL))
        }

        return alertController
    }

    func displayAlertController(_ alert: UIAlertController, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            guard let topViewController = self.topViewController() else { return }

            topViewController.present(alert, animated: true, completion: completion)
        }
    }

    func topViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }

        var topViewController: UIViewController = rootViewController

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }

    // MARK: Custom Alert Actions

    private func dismissActon() -> UIAlertAction {
        let alertTitle = NSLocalizedString("Dismiss", comment: "Button title for dismissing the update AlertView")

        return UIAlertAction(title: alertTitle, style: .default)
    }

    private func updateAction(_ updateURL: URL) -> UIAlertAction {
        let alertTitle = NSLocalizedString("Update", comment: "Button title for accepting the update AlertView")

        let updateHandler: (UIAlertAction) -> Void = { _ in
            guard UIApplication.shared.canOpenURL(updateURL) else { return }

            DispatchQueue.main.async {
                UIApplication.shared.open(updateURL)
            }
        }

        return UIAlertAction(title: alertTitle, style: .default, handler: updateHandler)
    }

#endif

}
