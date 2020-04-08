import Foundation

public struct AlertConfiguration: Dialogable {

    var message = ""
    var blocking = false

    init?(message: String, blocking: Bool) {
        guard !message.isEmpty else { return nil }

        self.message = message
        self.blocking = blocking
    }

}

extension AlertConfiguration: Rememberable {
    var rememberKey: String { "LAST_ALERT" }
    var rememberString: String { message }
}
