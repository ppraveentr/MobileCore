//
//  FTColor.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 01/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

/*
 Here's a correct table of percentages to hex values. E.g. for 50% white you'd use #80FFFFFF.
 100% — FF
 95% — F2
 90% — E6
 85% — D9
 80% — CC
 75% — BF
 70% — B3
 65% — A6
 60% — 99
 55% — 8C
 50% — 80
 45% — 73
 40% — 66
 35% — 59
 30% — 4D
 25% — 40
 20% — 33
 15% — 26
 10% — 1A
 5% — 0D
 0% — 00

 Percentage to hex values:
 https://stackoverflow.com/questions/15852122/hex-transparency-in-colors
 */

public extension UIColor {
    
    convenience init(red: UInt32, green: UInt32, blue: UInt32, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            a: a
        )
    }
    
    fileprivate convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: UInt32, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16 & 0xFF),
            green: (rgb >> 8 & 0xFF),
            blue: (rgb >> 0 & 0xFF),
            a: a
        )
    }
    
    convenience init(rgba: UInt32) {
        self.init(
            red: (rgba >> 24 & 0xFF),
            green: (rgba >> 16 & 0xFF),
            blue: (rgba >> 8 & 0xFF),
            a: CGFloat(rgba >> 0 & 0xFF)
        )
    }
    
    func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    func hexAlphaString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba: Int = (Int)(r * 255) << 24 | (Int)(g * 255) << 16 | (Int)(b * 255) << 8 | (Int)(a * 255) << 0
        return String(format: "#%06x", rgba)
    }
    
    static func hexColor (_ hex: String) -> UIColor? {

        // Check if its acutal hex coded string
        if !hex.hasPrefix("#") {
            return nil
        }

        // Strip non-alphanumerics, and Make it capitalized
        let cString: String = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()

        // Read hex string into Int32
        var int = UInt32()
        Scanner(string: cString).scanHexInt32(&int)
        
        let r: UInt32
        let g: UInt32
        let b: UInt32
        var a: UInt32 = 255
        switch hex.count - 1 {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        return UIColor(red: r, green: g, blue: b, a: CGFloat(a) / 255.0)
    }
    
    func generateImage(opacity: CGFloat = 1,
                       contextSize: CGSize = CGSize(width: 1, height: 1),
                       contentsScale: CGFloat = CGFloat.greatestFiniteMagnitude) -> UIImage? {
        let rect = CGRect(origin: .zero, size: contextSize)
        
        if contentsScale == CGFloat.greatestFiniteMagnitude {
            UIGraphicsBeginImageContext(contextSize)
        }
        else {
            UIGraphicsBeginImageContextWithOptions(contextSize, false, contentsScale)
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.setAlpha(opacity)
            context.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    // Amount should be between 0 and 1
    func lighterColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: UIColor.white, amount: amount)
    }
    
    func darkerColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: UIColor.black, amount: amount)
    }
    
    static func blendColors(color: UIColor, destinationColor: UIColor, amount: CGFloat) -> UIColor {
        var amountToBlend = amount
        if amountToBlend > 1 {
            amountToBlend = 1.0
        }
        else if amountToBlend < 0 {
            amountToBlend = 0
        }
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: &alpha) // Gets the rgba values (0-1)
        
        // Get the destination rgba values
        var destR: CGFloat = 0.0
        var destG: CGFloat = 0.0
        var destB: CGFloat = 0.0
        var destAlpha: CGFloat = 0.0
        destinationColor.getRed(&destR, green: &destG, blue: &destB, alpha: &destAlpha)
        
        r = amountToBlend * (destR * 255) + (1 - amountToBlend) * (r * 255)
        g = amountToBlend * (destG * 255) + (1 - amountToBlend) * (g * 255)
        b = amountToBlend * (destB * 255) + (1 - amountToBlend) * (b * 255)
        alpha = abs(alpha / destAlpha)
        
        return UIColor(red: r, green: g, blue: b, a: alpha)
    }
}

public extension UIImage {
    
    convenience init?(color: UIColor) {
        if let cgImage = color.generateImage()?.cgImage {
            self.init(cgImage: cgImage)
        }
        return nil
    }
    
    func getColor(a: CGFloat = -10) -> UIColor? {
        
        guard
            let pixelData = self.cgImage?.dataProvider?.data,
            let data = CFDataGetBytePtr(pixelData) else {
            return nil
        }
        
        // The image is png
        let pixelInfo = Int(0) * 4
        let red = data[pixelInfo]
        let green = data[(pixelInfo + 1)]
        let blue = data[pixelInfo + 2]
        let alpha = data[pixelInfo + 3]
        
        return UIColor(red: UInt32(red), green: UInt32(green), blue: UInt32(blue), a: (a > 0 ? a : CGFloat(alpha)) / 255.0)
    }
}
