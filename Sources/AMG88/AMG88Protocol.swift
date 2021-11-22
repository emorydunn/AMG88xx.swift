//
//  File.swift
//  
//
//  Created by Emory Dunn on 11/22/21.
//

import Foundation

/// A protocol that defines the methods for interacting with an AMG88xx sensor. 
public protocol AMG88Protocol {
    
    // MARK: Interrupt Mode
    func setInterruptLevels(high: Float, low: Float, hysteresis: Float)
    
    func getInterrupts() -> [[Bool]]
    
    func clearInterrupt()
    
    func enableInterrupt()
    
    func disableInterrupt()
    
    // MARK: Average Mode
    func enableMovingAverage()
    
    func disableMovingAverage()
    
    // MARK: Read Data
    
    func readThermistor() -> Float
    
    func readPixels() -> [Float]
}
