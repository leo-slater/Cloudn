// Cloudn · SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
import XCTest
@testable import CloudnKit

final class LocalizationTests: XCTestCase {
    func testInterpolatedErrorKeepsProviderMessage() {
        let raw = "网络请求失败：A 100% result"
        let error = CloudnError(LocalizedMessage("网络请求失败：%1$@", "A 100% result"), code: 7)
        XCTAssertEqual(error, CloudnError(raw, code: 7))
        XCTAssertEqual(error.localizedDescription, raw)

        let english = Bundle.module.url(forResource: "en", withExtension: "lproj").flatMap(Bundle.init(url:))
        let format = english?.localizedString(forKey: "网络请求失败：%1$@", value: nil, table: nil)
        XCTAssertEqual(format, "Network request failed: %1$@")
        XCTAssertEqual(format.map { CloudnLocalization.format($0, ["A 100% result"]) },
                       "Network request failed: A 100% result")
    }

    func testFormatAllowsReorderingAndLiteralPercent() {
        XCTAssertEqual(CloudnLocalization.format("%2$@ · %1$@%%", ["75", "Download"]), "Download · 75%")
    }
}
