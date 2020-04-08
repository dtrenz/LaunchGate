import Foundation

protocol Rememberable {
    var rememberKey: String { get }
    var rememberString: String { get }
}

extension Rememberable {

    func isNotRemembered() -> Bool {
        !Memory.contains(self)
    }

}
