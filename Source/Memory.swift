import Foundation

enum Memory {

    static let userPrefs = UserDefaults.standard

    static func remember(_ item: Rememberable) {
        userPrefs.set(item.rememberString, forKey: item.rememberKey)
    }

    static func forget(_ item: Rememberable) {
        userPrefs.removeObject(forKey: item.rememberKey)
    }

    static func contains(_ item: Rememberable) -> Bool {
        userPrefs.object(forKey: item.rememberKey) as? String == item.rememberString
    }

}
