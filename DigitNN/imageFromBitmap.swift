import Cocoa
import Upsurge

public struct PixelData {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}

private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

public func imageFromARGB32Bitmap(pixels:[PixelData], width:Int, height:Int)->NSImage {
    let bitsPerComponent:Int = 8
    let bitsPerPixel:Int = 32
    
    assert(pixels.count == Int(width * height))
    
    var data = pixels // Copy to mutable []
    let providerRef = CGDataProvider(
            data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size)
        )

    let cgim = CGImage.init(width: width,
                            height: height,
                            bitsPerComponent: bitsPerComponent,
                            bitsPerPixel: bitsPerPixel,
                            bytesPerRow: width * Int(MemoryLayout<PixelData>.size),
                            space: rgbColorSpace,
                            bitmapInfo: bitmapInfo,
                            provider: providerRef!,
                            decode: nil,
                            shouldInterpolate: true,
                            intent: CGColorRenderingIntent.defaultIntent
    )
    return NSImage(cgImage: cgim!, size: NSSize(width: width, height: height))
}

func imageFromRow(xi: ValueArray<Double>, length: Int) -> NSImage {
    
    var pixelData = [PixelData](repeating: PixelData(a: 0, r: 0, g: 0, b: 0), count: Int(BoxLength2))
    
    for y in 0..<length {
        for x in 0..<length {
            let idx = y*length + x
            var xii = xi[idx] * 256
            
            if xii < 0 {
                xii = 0
            }
            
            if xii > 255 {
                xii = 255
            }
            
            let v = UInt8(255-xii)
            
            if v < 255 {
                let pixel = PixelData(a: 255-v, r: v, g: v, b: v)
                pixelData[y + x*length] = pixel
            }
        }
    }
    
    return imageFromARGB32Bitmap(pixels: pixelData, width:length, height:length)
}
