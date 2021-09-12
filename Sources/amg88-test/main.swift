//
//  main.swift
//  
//
//  Created by Emory Dunn on 9/11/21.
//

import Foundation
import SwiftyGPIO
import AMG88xx

let averageMode = CommandLine.arguments.contains("--avg")
let loopMode = CommandLine.arguments.contains("--loop")

let interface = SwiftyGPIO.hardwareI2Cs(for: .RaspberryPiPlusZero)![1]

let sensor = AMG88(interface)

if averageMode {
    sensor.enableMovingAverage()
}

let temp = sensor.readThermistor()
print("Thermistor Temp:", temp)

if loopMode {
    while true {
        let pixels = sensor.readPixels()
        print("Pixels:")
        pixels.logPagedData()
        
        sleep(1)
    }
} else {
    let pixels = sensor.readPixels()
    print("Pixels:")
    pixels.logPagedData()
}

