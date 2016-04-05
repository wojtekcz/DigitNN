import Cocoa
import Upsurge

public struct PixelData {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}

private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)

//public func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt)->UIImage {
public func imageFromARGB32Bitmap(pixels:[PixelData], width:Int, height:Int)->NSImage {
    let bitsPerComponent:Int = 8
    let bitsPerPixel:Int = 32
    
    assert(pixels.count == Int(width * height))
    
    var data = pixels // Copy to mutable []
    let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )

    let cgim = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width * Int(sizeof(PixelData)),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            CGColorRenderingIntent.RenderingIntentDefault
        )
    return NSImage(CGImage: cgim!, size: NSSize(width: width, height: height))
    //return UIImage(CGImage: cgim)
}

func imageFromRow(xi: ValueArray<Double>, length: Int) -> NSImage {
    
    var image = NSImage()
    //let length: Int = BoxLength
    var pixelData = [PixelData](count: Int(BoxLength2), repeatedValue: PixelData(a: 0, r: 0, g: 0, b: 0))
    
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
    
    return imageFromARGB32Bitmap(pixelData, width:length, height:length)
}
