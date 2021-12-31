//
//  PowerModes.swift
//  
//
//  Created by Emory Dunn on 9/10/21.
//

import Foundation
import SwiftyGPIO

enum Registers {
    /// Set operating mode
    static let powerControl: UInt8 = 0x00
    
    /// Software Reset
    static let reset: UInt8 = 0x01
    
    /// Frame rate
    static let frameRate: UInt8 = 0x02
    
    /// Interrupt Function
    static let interruptControl: UInt8 = 0x03
    
    /// Interrupt Flag, low voltage flag
    static let status: UInt8 = 0x04
    
    /// Interrupt Flag Clear
    static let statusClear: UInt8 = 0x05
    
    // 0x06 reserved
    
    /// Moving Average Output
    static let average: UInt8 = 0x07
    
    /// Interrupt upper value (Lower level)
    static let interruptHighLevelLow: UInt8 = 0x08
    
    /// Interrupt upper value (Upper level)
    static let interruptHighLevelHigh: UInt8 = 0x09
    
    /// Interrupt lower value (Upper level)
    static let interruptLowLevelLow: UInt8 = 0x0A
    
    /// Interrupt lower value (Upper level)
    static let interruptLowLevelHigh: UInt8 = 0x0B
    
    /// Interrupt hysteresis value (Lower level)
    static let interruptHysteresisLow: UInt8 = 0x0C
    
    /// Interrupt hysteresis value (Upper level)
    static let interruptHysteresisHigh: UInt8 = 0x0D
    
    /// Thermistor Output Value (Lower level)
    static let ThermistorOutputLow: UInt8 = 0x0E
    
    /// Thermistor Output Value (Upper level)
    static let ThermistorOutputHigh: UInt8 = 0x0F
    
    /// Pixel 1~8 Interrupt Result
    static let interruptTableOffset: UInt8 = 0x10
    
    static let pixelOffset: UInt8 = 0x80
    
}

public enum PowerMode: UInt8 {
    case normal = 0x00
    case sleep = 0x01
    case standby60 = 0x20
    case standby10 = 0x21
}

public enum SWReset: UInt8 {
    case flagReset = 0x30
    case initialReset = 0x3F
}

public enum FrameRate: UInt8 {
    case fps10 = 0x00
    case fps1 = 0x01
}

public enum InterruptEnable: UInt8 {
    case enabled = 0x01
    case disabled = 0x00
}

public enum InterruptMode: UInt8 {
    case difference = 0x00
    case absolute = 0x01
}

extension I2CInterface {
    func writeByte<R: RawRepresentable>(_ address: Int, command: UInt8, value: R) where R.RawValue == UInt8 {
        writeByte(address, command: command, value: value.rawValue)
    }
}
