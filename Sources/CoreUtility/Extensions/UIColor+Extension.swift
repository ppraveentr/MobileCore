//
//  Color+Extension.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 01/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

/*
 Here's the table of percentages to hex values. E.g. for 50% white you'd use #FFFFFF80.
 100% — FF :: 95% — F2 :: 90% — E6 :: 85% — D9 :: 80% — CC :: 75% — BF :: 70% — B3 :: 65% — A6
  60% — 99 :: 55% — 8C :: 50% — 80 :: 45% — 73 :: 40% — 66 :: 35% — 59 :: 30% — 4D :: 25% — 40
  20% — 33 :: 15% — 26 :: 10% — 1A ::  5% — 0D ::  0% — 00
 */

public extension UIColor {
    convenience init(red: UInt64, green: UInt64, blue: UInt64, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: a)
    }
    
    // MARK: rgb: UInt64, a: CGFloat
    // UIColor(rgb: 13_158_600, a: 0.5) --> "#C8C8C87F"
    convenience init(rgb: UInt64, a: CGFloat = 1.0) {
        self.init(red: (rgb >> 16 & 0xFF), green: (rgb >> 8 & 0xFF), blue: (rgb >> 0 & 0xFF), a: a)
    }
    
    // UIColor(red: 200, green: 200, blue: 200, a: 0.5) --> "#C8C8C8"
    func hexString() -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    // MARK: rgba: UInt64
    // UIColor(rgb: 13_158_600) --> "#C8C8C8FF"
    convenience init(rgba: UInt64) {
        let (r, g, b, a) = (rgba >> 24 & 0xFF, rgba >> 16 & 0xFF, rgba >> 8 & 0xFF, rgba >> 0 & 0xFF)
        self.init(red: r, green: g, blue: b, a: CGFloat(a) / 255)
    }
    
    //  UIColor(red: 200, green: 200, blue: 200, a: 1.0) --> "#C8C8C8FF"
    //  UIColor(red: 200, green: 200, blue: 200, a: 0.5) --> "#C8C8C87F"
    func hexAlphaString() -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba: UInt64 = (UInt64)(r * 255) << 24 | (UInt64)(g * 255) << 16 | (UInt64)(b * 255) << 8 | (UInt64)(a * 255)
        return String(format: "#%08x", rgba)
    }
    
    // MARK: hexString: String: "#C8C8C87F"
    //  "#C8C8C87F" --> UIColor(red: 200, green: 200, blue: 200, a: 0.5)
    static func hexColor(_ hexString: String) -> UIColor? {
        // Check if its acutal hex coded string
        guard hexString.hasPrefix("#") else { return nil }
        // Strip non-alphanumerics, and Make it capitalized
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()
        // Read hex string into Int64
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        switch hex.count {
        case 3: // RGB (12-bit)
            let (r, g, b) = ((int >> 8 & 0xF) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            return UIColor(red: r, green: g, blue: b)
        case 6: // RGB (24-bit)
            return UIColor(rgb: int)
        case 8: // ARGB (32-bit)
            return UIColor(rgba: int)
        default:
            return nil
        }
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
}

public extension UIImage {
    convenience init?(color: UIColor) {
        guard let cgImageValue = color.generateImage()?.cgImage else { return nil }
        self.init(cgImage: cgImageValue)
    }
    
    func getColor(a: CGFloat = -10) -> UIColor? {
        guard let pixelData = self.cgImage?.dataProvider?.data,
              let data = CFDataGetBytePtr(pixelData) else { return nil }
        // The image is png
        let pixelInfo = Int(0) * 4
        let red = data[pixelInfo]
        let green = data[(pixelInfo + 1)]
        let blue = data[pixelInfo + 2]
        let alpha = data[pixelInfo + 3]
        
        return UIColor(red: UInt64(red), green: UInt64(green), blue: UInt64(blue), a: (a > 0 ? a : CGFloat(alpha)) / 255.0)
    }
}
