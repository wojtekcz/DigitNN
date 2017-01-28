//
//  DigitView.swift
//  DigitNN
//
//  Created by Wojciech Czarnowski on 21.03.2016.
//  Copyright © 2016 JATAR. All rights reserved.
//

import Cocoa

let BoxLength = 20
let BoxLength2 = BoxLength * BoxLength

class DigitView: NSView {

    var image = NSImage()
    let length: Int = BoxLength
    var pixelData = [PixelData](repeating: PixelData(a: 255, r: 192, g: 0, b: 0), count: Int(BoxLength2))
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // Update pixels
        for y in 0..<length {
            for x in 0..<length {
                let pixel = PixelData(a: 255,
                    r: UInt8(Double(y)*255.0/Double(length)),
                    g: UInt8(Double(length - x)*255.0/Double(length)),
                    b: UInt8(Double(x)*255.0/Double(length)))
                pixelData[y*length + x] = pixel
            }
        }
        
        image = imageFromARGB32Bitmap(pixels: pixelData, width:length, height:length)
    }
    
    func updateImage() {
        image = imageFromARGB32Bitmap(pixels: pixelData, width:length, height:length)
        self.setNeedsDisplay(self.bounds)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        image.draw(in: self.bounds)
    }
    
}
