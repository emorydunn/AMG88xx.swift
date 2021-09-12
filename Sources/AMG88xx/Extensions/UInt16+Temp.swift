//
//  UInt16+Temp.swift
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
        if self >> 11 == 1 {
            // Convert to a signed int, then a float
            return Float(Int(self) - 1 << 12)
        } else {
            return Float(self)
        }
    }
}
