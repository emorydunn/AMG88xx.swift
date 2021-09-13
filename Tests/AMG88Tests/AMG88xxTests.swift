import XCTest
@testable import AMG88
import SwiftyGPIO

final class AMG88xxTests: XCTestCase {
    func test12BitMagnitude() {
        XCTAssertEqual(UInt16(0b0000_0000_0100).fromSignedMag12(), 4) // +0.25ºC
        XCTAssertEqual(UInt16(0b1000_0000_0100).fromSignedMag12(), -4) // -0.25ºC
    }
    
    func test12BitInt() {
        XCTAssertEqual(UInt16(0b0000_0110_0100).fromTwosCompliment(), 100) // +25ºC
        XCTAssertEqual(UInt16(0b1111_1001_1100).fromTwosCompliment(), -100) // -25ºC
    }
    
    func testFloatToCompliment() {
        XCTAssertEqual(UInt16(0b0000_0110_0100), Float(100).twosCompliment()) // +25ºC
        XCTAssertEqual(UInt16(0b1111_1001_1100), Float(-100).twosCompliment()) // -25ºC
    }
    
    func testBytes() {
        let value: UInt16 = 0b1111_1001_1100
        
        XCTAssertEqual(value.bytes.1, 0b1111)
        XCTAssertEqual(value.bytes.0, 0b1001_1100)
    }
    
    func testThermistor() {
        let sensor = AMG88(MockAMG())
        
        XCTAssertEqual(sensor.readThermistor(), 25)
    }
    
    func testPixel() {
        let sensor = AMG88(MockAMG())
        
        XCTAssertEqual(sensor.readPixel(at: 0), 25)
        
        XCTAssertEqual(sensor.readPixel(at: 2), -25)
    }
}
