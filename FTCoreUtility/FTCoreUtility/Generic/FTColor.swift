//
//  FTColor.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 01/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIColor {
    
     fileprivate convenience init(red: UInt32, green: UInt32, blue: UInt32, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
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
    
    public convenience init(rgb: UInt32, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16 & 0xFF),
            green: (rgb >> 8 & 0xFF),
            blue: (rgb >> 0 & 0xFF),
            a: a
        )
    }
    
    public convenience init(rgba: UInt32) {
        self.init(
            red: (rgba >> 24 & 0xFF),
            green: (rgba >> 16 & 0xFF),
            blue: (rgba >> 8 & 0xFF),
            a: CGFloat(rgba >> 0 & 0xFF)
        )
    }
    
    func hexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    public static func hexColor (_ hex:String) -> UIColor? {

        // Check if its acutal hex coded string
        if !hex.hasPrefix("#") {
            return nil
        }

        // Strip non-alphanumerics, and Make it capitalized
        let cString:String = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()

        // Read hex string into Int32
        var int = UInt32()
        Scanner(string: cString).scanHexInt32(&int)
        
        let a, r, g, b: UInt32
        switch hex.length-1 {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        return UIColor(red: r, green: g, blue: b, a: CGFloat(a) / 255.0)
    }
    
    public func generateImage(opacity: CGFloat = 1, contextSize: CGSize = CGSize(width: 1, height: 1),
                              contentsScale: CGFloat = CGFloat.greatestFiniteMagnitude) -> UIImage {
        
        let rect = CGRect(origin: .zero, size: contextSize)
        
        if contentsScale == CGFloat.greatestFiniteMagnitude {
            UIGraphicsBeginImageContext(contextSize)
        } else {
            UIGraphicsBeginImageContextWithOptions(contextSize, false, contentsScale)
        }
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.setAlpha(opacity)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    // Amount should be between 0 and 1
    public func lighterColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: UIColor.white, amount: amount)
    }
    
    public func darkerColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: UIColor.black, amount: amount)
    }
    
    public static func blendColors(color: UIColor, destinationColor: UIColor, amount : CGFloat) -> UIColor {
        var amountToBlend = amount
        if amountToBlend > 1{
            amountToBlend = 1.0
        }
        else if amountToBlend < 0 {
            amountToBlend = 0
        }
        
        var r,g,b, alpha : CGFloat
        r = 0
        g = 0
        b = 0
        alpha = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &alpha) //gets the rgba values (0-1)
        
        // Get the destination rgba values
        var dest_r, dest_g, dest_b, dest_alpha : CGFloat
        dest_r = 0
        dest_g = 0
        dest_b = 0
        dest_alpha = 0
        destinationColor.getRed(&dest_r, green: &dest_g, blue: &dest_b, alpha: &dest_alpha)
        
        r = amountToBlend * (dest_r * 255) + (1 - amountToBlend) * (r * 255)
        g = amountToBlend * (dest_g * 255) + (1 - amountToBlend) * (g * 255)
        b = amountToBlend * (dest_b * 255) + (1 - amountToBlend) * (b * 255)
        alpha = abs(alpha / dest_alpha)
        
        return UIColor(red: r, green: g, blue: b, a: alpha)
    }

}

public extension UIImage {
    
    public func getColor(atPoint: CGPoint = CGPoint(x: 1, y: 1), a: CGFloat = -10) -> UIColor? {
        
        guard
            let pixelData = self.cgImage?.dataProvider?.data,
            let data = CFDataGetBytePtr(pixelData) else {
            return nil
        }
        
//        let pixelInfo: Int = Int((self.size.width  * atPoint.y) + atPoint.x ) * 4; // The image is png
        // The image is png
        let pixelInfo: Int = Int(0) * 4
        
        let red = data[pixelInfo]
        let green = data[(pixelInfo + 1)]
        let blue = data[pixelInfo + 2]
        let alpha = data[pixelInfo + 3]
        
        return UIColor(red: UInt32(red), green: UInt32(green), blue: UInt32(blue), a: (a > 0 ? a : CGFloat(alpha)) / 255.0)
    }
    
}
