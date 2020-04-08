import Foundation

public struct UpdateConfiguration: Dialogable {

  var version = ""
  var message = ""

  init?(version: String, message: String) {
    guard !version.isEmpty else { return nil }
    guard !message.isEmpty else { return nil }

    self.version = version
    self.message = message
  }

}

extension UpdateConfiguration: Rememberable {
    var rememberKey: String { "OPTIONAL_UPDATE" }
    var rememberString: String { version }
}
