//
//  UIImage.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 10.05.2020.
//  Copyright © 2020 Denis Svichkarev. All rights reserved.
//

import UIKit

public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

extension UIImage {
   func pixelData() -> [UInt8]? {
       let size = self.size
       let dataSize = size.width * size.height * 4
       var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
       let colorSpace = CGColorSpaceCreateDeviceRGB()
       let context = CGContext(data: &pixelData,
                               width: Int(size.width),
                               height: Int(size.height),
                               bitsPerComponent: 8,
                               bytesPerRow: 4 * Int(size.width),
                               space: colorSpace,
                               bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
       guard let cgImage = self.cgImage else { return nil }
       context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

       return pixelData
   }
    
    static func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
        guard width > 0 && height > 0 else { return nil }
        guard pixels.count == width * height else { return nil }

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let bitsPerComponent = 8
        let bitsPerPixel = 32

        var data = pixels // Copy to mutable []
        guard let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size)) else { return nil }

        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * MemoryLayout<PixelData>.size,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
            )
            else { return nil }

        return UIImage(cgImage: cgim)
    }
}

func noir(originalImage: UIImage) -> UIImage {
    let context = CIContext(options: nil)

    //Auto Adjustment to Input Image
    var inputImage = CIImage(image: originalImage)
    
    let filters = inputImage!.autoAdjustmentFilters()

    for filter: CIFilter in filters {
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        inputImage = filter.outputImage
    }
    let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
    //originalImage = UIImage(cgImage: cgImage!)

    //Apply noir Filter
    let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
    currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)

    let output = currentFilter!.outputImage
    let cgimg = context.createCGImage(output!, from: output!.extent)
    let processedImage = UIImage(cgImage: cgimg!)
    return processedImage
}

func convertImageToBW(image:UIImage) -> UIImage {

    let filter = CIFilter(name: "CIPhotoEffectMono")

    // convert UIImage to CIImage and set as input

    let ciInput = CIImage(image: image)
    filter?.setValue(ciInput, forKey: "inputImage")

    // get output CIImage, render as CGImage first to retain proper UIImage scale

    let ciOutput = filter?.outputImage
    let ciContext = CIContext()
    let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)

    return UIImage(cgImage: cgImage!)
}
