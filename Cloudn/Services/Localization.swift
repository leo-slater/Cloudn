// Cloudn · SPDX-License-Identifier: AGPL-3.0-or-later
import CloudnKit

func L(_ key: String, _ arguments: String...) -> String {
    CloudnLocalization.text(key, arguments: arguments)
}

func displayError(_ error: any Error) -> String {
    CloudnLocalization.error(error)
}
