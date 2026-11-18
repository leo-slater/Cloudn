// Cloudn · SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation

func L(_ key: String, _ arguments: String...) -> String {
    let template = Bundle.main.localizedString(forKey: key, value: key, table: nil)
    guard !arguments.isEmpty else { return template }
    return String(format: template, arguments: arguments)
}
