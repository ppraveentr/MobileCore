//
//  UIView+Utiltiy.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 20/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIView {

    func addBorder(color: UIColor = .lightGray, borderWidth: CGFloat = 1.5) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
    
    // calculate - systemLayoutSizeFitting
    func compressedSize(_ size: CGSize = .zero,
                        _ offSet: CGSize = .zero,
                        widthPriority: UILayoutPriority = .required,
                        heightPriority: UILayoutPriority = .fittingSizeLevel ) -> CGSize {
        
        if size == .zero {
            let compressedSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return compressedSize
        }
        
        let size = self.systemLayoutSizeFitting(
            size,
            withHorizontalFittingPriority: widthPriority,
            verticalFittingPriority: heightPriority
        )
        
        return CGSize(width: size.width - offSet.width, height: size.height - offSet.height)
    }
    
    // Find subView based on output type
    func findInSubView<T>() -> T? {
        
        for val in self.subviews.compactMap({ $0 }) {
            if val is T {
                return val as? T
            }
            else if !val.subviews.isEmpty {
                let subType: T? =  val.findInSubView()
                return subType
            }
        }
        return nil
    }
    
    // Find all UIImageView with 'height <= 1'
    func findShadowImage() -> [UIImageView]? {
        
        var imgs: [UIImageView] = []
        
        if self is UIImageView && self.bounds.height <= 1, let selfImamge = self as? UIImageView {
            return [selfImamge]
        }
        
        for subview in self.subviews {
            if let imageViews = subview.findShadowImage(), !imageViews.isEmpty {
                imgs.append(contentsOf: imageViews)
            }
        }
        
        return imgs
    }
    
    // Remove all UIImageView's with 'height <= 1'
    func hideShadowImage() {
        
        self.findShadowImage()?.forEach { shadowImageView in
            shadowImageView.isHidden = true
        }
    }
}
