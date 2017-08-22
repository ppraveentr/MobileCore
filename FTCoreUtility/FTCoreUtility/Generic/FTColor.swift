//
//  FTColor.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 01/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIColor {
    
    public class func hexColor (_ hex:String) -> UIColor? {
                
        let cString:String = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()
        
        var int = UInt32()
        Scanner(string: cString).scanHexInt32(&int)
        
        let a, r, g, b: UInt32
        switch hex.characters.count-1 {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        return UIColor(colorLiteralRed: Float(r), green: Float(g), blue: Float(b), alpha: Float(a) / 255)
    }
    
    public func generateImage(opacity: CGFloat = 1, contextSize: CGSize = CGSize(width: 1, height: 1), contentsScale: CGFloat = CGFloat.greatestFiniteMagnitude) -> UIImage {
        
        let rect = CGRect(origin: .zero, size: contextSize)
        
        if contentsScale == CGFloat.greatestFiniteMagnitude {
            UIGraphicsBeginImageContext(contextSize)
        }else {
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
}
