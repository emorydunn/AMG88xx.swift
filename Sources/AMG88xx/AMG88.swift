import Foundation
import SwiftyGPIO

public class AMG88 {

    var interface: I2CInterface
    var address: Int
    
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
        interface.writeByte(address, command: Registers.pctl, value: PowerMode.normal)
        
        // Software Reset
        interface.writeByte(address, command: Registers.reset, value: SWReset.initialReset)
        
        disableInterrupt()
        
        // Set to 10 FPS
        interface.writeByte(address, command: Registers.fpsc, value: FrameRate.fps10)
        
        sleep(1)
    
    }
    
    
    // MARK: Interrupt Mode
    public func setInterruptLevels(high: Float, low: Float, hysteresis: Float = 0.95) {
        // Set the high level
        let highConv = (high / pixelTempConversion).twosCompliment()
        interface.writeWord(address, command: Registers.inthl, value: highConv)
        
        // Set the low level
        let lowConv = (low / pixelTempConversion).twosCompliment()
        interface.writeWord(address, command: Registers.intll, value: lowConv)

        // Set the hysteresis level
        let hysConv = (low / pixelTempConversion).twosCompliment()
        interface.writeWord(address, command: Registers.ihysl, value: hysConv)
    }
    
    /// Determine which pixels triggered an interrupt.
    ///
    /// The pixels are arranged so that pixel 1 is at `[0, 0]` and pixel 64 is at `[7, 7]`.
    ///
    /// - Returns: A two-dimensional array indicating which pixels triggered the interrupt signal.
    public func getInterrupts() -> [[Bool]] {
        stride(from: 0, to: 7, by: 1).reversed().map { offset in
            interface.readI2CData(address, command: Registers.intOffset + UInt8(offset)).map {
                Bool($0 == 1)
            }
        }
    }
    
    public func clearInterrupt() {
        interface.writeByte(address, command: Registers.reset, value: SWReset.flagReset)
    }
    
    public func enableInterrupt() {
        interface.writeByte(address, command: Registers.intc, value: 1)
    }
    
    public func disableInterrupt() {
        interface.writeByte(address, command: Registers.intc, value: 0)
    }
    
    // MARK: Average Mode
    public func enableMovingAverage() {
        interface.writeByte(address, command: Registers.ave, value: 1)
    }
    
    public func disableMovingAverage() {
        interface.writeByte(address, command: Registers.ave, value: 0)
    }
    
    // MARK: Temperatures
    
    /// Read the temperature value from the internal thermistor.
    /// - Returns: The temperature in Celsius.
    public func readThermistor() -> Float {
        let raw = interface.readWord(address, command: Registers.tthl)
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
    func readPixel(at offset: Int) -> Float {
        let low = Registers.pixelOffset + UInt8(offset)
        let raw = interface.readWord(address, command: low)
        
        return raw.fromTwosCompliment() * pixelTempConversion
    }
    
}
