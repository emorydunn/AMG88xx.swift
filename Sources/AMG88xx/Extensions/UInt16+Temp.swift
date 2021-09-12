//
//  UInt16+Temp.swift
//  
//
//  Created by Emory Dunn on 9/11/21.
//

import Foundation

extension UInt16 {
    /// Convert a 12-bit signed magnitude value to a floating point number.
    ///
    /// - Parameter value: The 12-bit signed magnitude value.
    /// - Returns: The converted floating point number.
    func signedMag12ToFloat() -> Float {
        let abs = self & 0x7FF
        return (self & 0x800) != 0 ? 0 - Float(abs) : Float(abs)
    }
}
