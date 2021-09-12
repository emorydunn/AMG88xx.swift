//
//  Number+Temp.swift
//  
//
//  Created by Emory Dunn on 9/11/21.
//

import Foundation

public extension UInt16 {
    /// Convert a 12-bit signed magnitude value to a floating point number.
    ///
    /// - Parameter value: The 12-bit signed magnitude value.
    /// - Returns: The converted floating point number.
    func fromSignedMag12() -> Float {
        let abs = self & 0x7FF
        return (self & 0x800) != 0 ? 0 - Float(abs) : Float(abs)
    }
    
    /// Convert the two's compliment representation to decimal.
    /// - Parameter bits: The number of bits in the binary representation.
    /// - Returns: A floating point number representing the decimal value.
    func fromTwosCompliment(bits: Int = 12) -> Float {
        // Shift to check the sign bit
        if self >> 11 == 1 {
            // Convert to a signed int, then a float
            return Float(Int(self) - 1 << bits)
        } else {
            return Float(self)
        }
    }
}

extension Float {
    /// Convert to two's compliment representation.
    /// - Parameter bits: The number of bits in the binary representation.
    /// - Returns: An unsigned integer of the two's compliment value.
    func twosCompliment(bits: Int = 12) -> UInt16 {
        if self > 0 {
            return UInt16(self)
        } else {
            return UInt16(Int(self) + 1 << bits)
        }
    }
}
