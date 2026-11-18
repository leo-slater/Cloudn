// Cloudn · SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation

/// The host app and CloudnKit share a strings table. Use the app's selected
/// language on iOS so the package also follows a per-app language override.
public enum CloudnLocalization {
    private static let bundle: Bundle = {
        #if os(iOS)
        if let language = Bundle.main.preferredLocalizations.first,
           let url = Bundle.module.url(forResource: language, withExtension: "lproj"),
           let localization = Bundle(url: url) {
            return localization
        }
        #endif
        return .module
    }()

    public static func text(_ key: String, _ arguments: String...) -> String {
        text(key, arguments: arguments)
    }

    public static func text(_ key: String, arguments: [String]) -> String {
        format(bundle.localizedString(forKey: key, value: key, table: nil), arguments)
    }

    static func format(_ template: String, _ arguments: [String]) -> String {
        guard !arguments.isEmpty else { return template }
        return String(format: template, arguments: arguments)
    }

    /// Use at the presentation boundary. The original error descriptions
    /// remain available to provider adapters that inspect their exact text.
    public static func error(_ error: any Error) -> String {
        switch error {
        case let error as CloudnError: return error.displayMessage
        case let error as VideoParseError: return error.displayMessage
        default: return text((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
        }
    }
}

struct LocalizedMessage: Sendable {
    let key: String
    let arguments: [String]

    init(_ key: String, _ arguments: String...) {
        self.key = key
        self.arguments = arguments
    }

    var original: String { CloudnLocalization.format(key, arguments) }
    var localized: String { CloudnLocalization.text(key, arguments: arguments) }
}
