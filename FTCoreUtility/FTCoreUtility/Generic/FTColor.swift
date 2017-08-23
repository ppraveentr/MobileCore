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
        
        return UIColor(red: r, green: g, blue: b, a: CGFloat(a) / 255.0)
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
