import XCTest
@testable import AMG88xx
import SwiftyGPIO

final class AMG88xxTests: XCTestCase {
    func testRegisterTemp() {
        XCTAssertEqual(UInt16(0b0000_0000_0100).signedMag12ToFloat(), 4)
        XCTAssertEqual(UInt16(0b1000_0000_0100).signedMag12ToFloat(), -4)
    }
}
