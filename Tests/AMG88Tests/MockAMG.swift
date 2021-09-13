//
//  File.swift
//  
//
//  Created by Emory Dunn on 9/12/21.
//

import Foundation
import SwiftyGPIO

class MockAMG: I2CInterface {
    
    var register: [UInt8]
    
    init() {
        self.register = Array(repeating: 0x00, count: 0xFF)
        
        // Set thermistor to +25ºc
        self.register[0x0E] = 0b1001_0000
        self.register[0x0F] = 0b0001
        
        // Set pixel 1 to +25ºc
        self.register[0x80] = 0b0110_0100
        self.register[0x81] = 0b0000
        
        // Set pixel 2 to -25ºc
        self.register[0x82] = 0b1001_1100
        self.register[0x83] = 0b1111
    }
    
    func isReachable(_ address: Int) -> Bool { return true }
    
    func setPEC(_ address: Int, enabled: Bool) { }
    
    func readByte(_ address: Int) -> UInt8 {
        fatalError("No-op in mock interface")
    }
    
    func readByte(_ address: Int, command: UInt8) -> UInt8 {
        return register[Int(command)]
    }
    
    func readWord(_ address: Int, command: UInt8) -> UInt16 {
        let low = UInt16(register[command])
        let high = UInt16(register[command + 1]) << 8
        return (high | low)
    }
    
    func readData(_ address: Int, command: UInt8) -> [UInt8] {
        fatalError("No-op in mock interface")
    }
    
    func readI2CData(_ address: Int, command: UInt8) -> [UInt8] {
        fatalError("No-op in mock interface")
    }
    
    func writeQuick(_ address: Int) {
        fatalError("No-op in mock interface")
    }
    
    func writeByte(_ address: Int, value: UInt8) {
        fatalError("No-op in mock interface")
    }
    
    func writeByte(_ address: Int, command: UInt8, value: UInt8) {
        register[command] = value
    }
    
    func writeWord(_ address: Int, command: UInt8, value: UInt16) {
        register[command] = value.bytes.0
        register[command + 1] = value.bytes.1
    }
    
    func writeData(_ address: Int, command: UInt8, values: [UInt8]) {
        fatalError("No-op in mock interface")
    }
    
    func writeI2CData(_ address: Int, command: UInt8, values: [UInt8]) {
        fatalError("No-op in mock interface")
    }
    
    
}

extension Array {
    subscript(index: UInt8) -> Element {
        get {
            self[Int(index)]
        }
        
        set {
            self[Int(index)] = newValue
        }
    }
}
