//
//  File.swift
//  
//
//  Created by Emory Dunn on 9/11/21.
//

import Foundation
import SwiftyGPIO
import AMG88xx

let interface = SwiftyGPIO.hardwareI2Cs(for: .RaspberryPiPlusZero)![1]

let sensor = AMG88(interface)

let temp = sensor.readThermistor()
print("Thermistor Temp:", temp)

let pixels = sensor.readPixels()
print("Pixels:")
pixels.logPagedData()
