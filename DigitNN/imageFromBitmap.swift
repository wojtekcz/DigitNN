import Cocoa

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
