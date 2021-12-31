import Foundation
import SwiftyGPIO

public class AMG88: AMG88Protocol {

    public let interface: I2CInterface
    public let address: Int
    
    let arraySize: Int = 64
    let pixelTempConversion: Float = 0.25
    let thermistorConversion: Float = 0.0625
    
    public init(_ interface: I2CInterface, address: Int = 0x69) {
        
        self.interface = interface
        self.address = address
        
        guard interface.isReachable(address) else {
            fatalError("Could not reach the sensor at address \(String(format: "0x%02X", address))")
        }
        
        // Enter normal mode
        interface.writeByte(address, command: Registers.powerControl, value: PowerMode.normal)
        
        // Software Reset
        interface.writeByte(address, command: Registers.reset, value: SWReset.initialReset)
        
        disableInterrupt()
        
        // Set to 10 FPS
        interface.writeByte(address, command: Registers.frameRate, value: FrameRate.fps10)
        
        sleep(1)
    
    }
    
    
    // MARK: Interrupt Mode
    /// Set high and low limits for the interrupt pin.
    ///
    /// When any pixel's temperature falls outside the limits the interrupt pin and interrupt pixel table are set.
    ///
    /// - Parameters:
    ///   - high: The high limit in Celsius.
    ///   - low: The low limit in Celsius.
    ///   - hysteresis: The hysteresis value.
    @available(*, deprecated, message: "Use the individual properties.")
    public func setInterruptLevels(high: Float, low: Float, hysteresis: Float = 0.95) {
        // Set the high level
        let highConv = (high / pixelTempConversion).twosCompliment()
        interface.writeWord(address, command: Registers.interruptHighLevelLow, value: highConv)
        
        // Set the low level
        let lowConv = (low / pixelTempConversion).twosCompliment()
        interface.writeWord(address, command: Registers.interruptLowLevelLow, value: lowConv)

        // Set the hysteresis level
        let hysConv = (low / pixelTempConversion).twosCompliment()
        interface.writeWord(address, command: Registers.interruptHysteresisLow, value: hysConv)
    }
    
    public var lowInterrupt: Float {
        get {
            let value = interface.readWord(address, command: Registers.interruptHighLevelLow)
            return value.fromTwosCompliment() * pixelTempConversion
        }
        set {
            let value = (newValue / pixelTempConversion).twosCompliment()
            interface.writeWord(address, command: Registers.interruptHighLevelLow, value: value)
        }
    }
    
    public var highInterrupt: Float {
        get {
            let value = interface.readWord(address, command: Registers.interruptLowLevelLow)
            return value.fromTwosCompliment() * pixelTempConversion
        }
        set {
            let value = (newValue / pixelTempConversion).twosCompliment()
            interface.writeWord(address, command: Registers.interruptLowLevelLow, value: value)
        }
    }
    
    public var hysteresis: Float {
        get {
            let value = interface.readWord(address, command: Registers.interruptHysteresisLow)
            return value.fromTwosCompliment() * pixelTempConversion
        }
        set {
            let value = (newValue / pixelTempConversion).twosCompliment()
            interface.writeWord(address, command: Registers.interruptHysteresisLow, value: value)
        }
    }
    
    /// Determine which pixels triggered an interrupt.
    ///
    /// The pixels are arranged so that pixel 1 is at `[0, 0]` and pixel 64 is at `[7, 7]`.
    ///
    /// - Returns: A two-dimensional array indicating which pixels triggered the interrupt signal.
    public func getInterrupts() -> [[Bool]] {
        stride(from: 0, to: 7, by: 1).reversed().map { offset in
            interface.readI2CData(address, command: Registers.interruptTableOffset + UInt8(offset)).map {
                Bool($0 == 1)
            }
        }
    }
    
    /// Clear the interrupt values.
    public func clearInterrupt() {
        interface.writeByte(address, command: Registers.reset, value: SWReset.flagReset)
    }
    
    /// Enable the interrupt pin.
    public func enableInterrupt() {
        var currentValue = interface.readByte(address, command: Registers.interruptControl)
        
        currentValue |= 1 << 0
        
        interface.writeByte(address, command: Registers.interruptControl, value: currentValue)
    }
    
    /// Disable the interrupt pin.
    public func disableInterrupt() {
        var currentValue = interface.readByte(address, command: Registers.interruptControl)
        
        currentValue &= ~(1 << 0)
        
        interface.writeByte(address, command: Registers.interruptControl, value: currentValue)
    }
    
    /// Set the interrupt to Difference Interrupt Mode
    public func setInterruptModeDifference() {
        var currentValue = interface.readByte(address, command: Registers.interruptControl)
        
        currentValue &= ~(1 << 0)
        
        interface.writeByte(address, command: Registers.interruptControl, value: currentValue)
    }
    
    /// Set the interrupt to Absolute Value Interrupt Mode
    public func setInterruptModeAbsolute() {
        var currentValue = interface.readByte(address, command: Registers.interruptControl)
        
        currentValue |= 1 << 1
        
        interface.writeByte(address, command: Registers.interruptControl, value: currentValue)
    }
    
    
    // MARK: Average Mode
    /// Enable moving average mode.
    public func enableMovingAverage() {
        interface.writeByte(address, command: Registers.average, value: 1)
    }
    
    /// Disable moving average mode.
    public func disableMovingAverage() {
        interface.writeByte(address, command: Registers.average, value: 0)
    }
    
    // MARK: Temperatures
    
    /// Read the temperature value from the internal thermistor.
    /// - Returns: The temperature in Celsius.
    public func readThermistor() -> Float {
        let raw = interface.readWord(address, command: Registers.ThermistorOutputLow)
        return raw.fromSignedMag12() * thermistorConversion
    }
    
    /// Read temperature values from the pixel registers.
    /// - Returns: An array of temperature values in Celsius.
    public func readPixels() -> [Float] {
        return stride(from: 0, to: arraySize * 2, by: 2).map { offset in
            readPixel(at: offset)
        }
    }
    
    /// Read the temperature at the specified _register_ offset.
    /// - Parameter offset: The register offset to read from.
    /// - Returns: The temperature value for the pixel.
    public func readPixel(at offset: Int) -> Float {
        let low = Registers.pixelOffset + UInt8(offset)
        let raw = interface.readWord(address, command: low)
        
        return raw.fromTwosCompliment() * pixelTempConversion
    }
    
}
