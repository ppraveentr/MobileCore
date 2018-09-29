//
//  FTRect.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 15/06/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

//CGRect
public extension CGRect {
    
    // Usefull if used in ObjC
    func getX() -> CGFloat { return self.origin.x }
    
    func getY() -> CGFloat { return self.origin.y }
    
    func getWidth() -> CGFloat { return self.size.width }
    
    func getHeight() -> CGFloat { return self.size.height }
    
    public mutating func normalize() -> CGRect {
        
        if !self.minX.isFinite { self.origin.x = 0.0 }
        
        if !self.minY.isFinite { self.origin.y = 0.0 }
        
        if !self.width.isFinite { self.size.width = 0.0 }
        
        if !self.height.isFinite { self.size.height = 0.0 }
        
        return self
    }
}

/**
 Outsets a CGSize with the insets in a UIEdgeInsets.
 */
public func FTEdgeInsetsOutsetSize(size: CGSize, insets: UIEdgeInsets) -> CGSize {
    return CGSize(width: insets.left + size.width + insets.right,
                  height: insets.top + size.height + insets.bottom)
}

/**
 Insets a CGSize with the insets in a UIEdgeInsets.
 */
public func FTEdgeInsetsInsetSize(size: CGSize, insets: UIEdgeInsets) -> CGSize {
    var rect: CGRect = .zero
    rect.size = size

    // WARNING
    return rect.inset(by: insets).size
}

/**
 CGSize of text based.
 */
public func FTTextSize(text: String?, font: UIFont,
                          constrainedSize: CGSize,
                          lineBreakMode: NSLineBreakMode) -> CGSize
{
    guard let text = text, text.length > 0 else {
        return .zero
    }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = lineBreakMode
    
    let attributes: [NSAttributedString.Key : Any] = [
        .font: font,
        .paragraphStyle: paragraphStyle,
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    let size = attributedString.boundingRect(with: constrainedSize,
                                  options: [.usesDeviceMetrics, .usesLineFragmentOrigin, .usesFontLeading],
                                  context: nil).size
    
    return FTCeilForSize(size)
}
