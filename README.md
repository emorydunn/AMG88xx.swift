# AMG88xx

A Swift library for the Panasonic AMG88 family of sensors. 

## Summary

This library can read temperature data from the AMG88 thermopile sensor. 


## Usage

Firstly, you'll need to obtain an instance of `I2CInterface` from `SwiftyGPIO` and use it to initialize the `AMG88` object:

```swift
import SwiftyGPIO
import AMG88xx

let i2cs = SwiftyGPIO.hardwareI2Cs(for: .RaspberryPiPlusZero)!
let i2c = i2cs[1]

let sensor = AMG88(i2c)
```

Once you have a sensor object you can read temperature data from the thermopile:

```swift
let pixels = sensor.readPixels()

pixels.logPagedData()
// 26 27 29 30 29 28 27 28
// 28 29 31 31 30 28 27 27
// 31 30 30 31 30 28 28 27
// 28 30 30 31 31 29 27 28
// 27 30 31 31 30 28 27 27
// 26 27 30 29 30 28 27 27
// 26 25 27 29 28 27 27 28
// 25 26 25 26 26 27 26 27
```

## Acknowledgments

Much of this library is inspired by the [Adafruit AMG88 library][adafruit] written by Dean Miller.  

[adafruit]: https://github.com/adafruit/Adafruit_AMG88xx
