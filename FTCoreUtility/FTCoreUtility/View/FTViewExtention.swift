//
//  UIView+Utility.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 10/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIView {
    
    public class func embedView(contentView: UIView) -> UIView {
        
        let local = self.init()
        local.backgroundColor = UIColor.clear
        
        local.pin(view: contentView, withEdgeInsets: [.All], withLayoutPriority: (UILayoutPriorityRequired - 1))
        local.pin(view: contentView, withEdgeInsets: [.CenterMargin], withLayoutPriority: UILayoutPriorityDefaultLow)
        local.pin(view: contentView, withEdgeInsets: [.EqualWidth, .Top])
        
        return local
    }
    
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    public class func getNIBFile() -> UINib? {
        return UINib(nibName: get_classNameAsString(obj: self) ?? "", bundle: nil)
    }
    
    public class func fromNib(named name: String) -> UIView? {
        let allObjects = Bundle.main.loadNibNamed(name, owner: nil, options: nil) ?? []
        if let nib = allObjects.first as? UIView {
            return nib
        }
        
        return nil
    }
    
    public class func fromNib() -> UIView? {
        return fromNib(named: get_classNameAsString(obj: self) ?? "")
    }
    
    public func removeAllConstraints() {
        var cont: [NSLayoutConstraint] = self.constraints
        cont.removeAll()
    }
    
    public func findShadowImage() -> UIImageView? {
        
        if self is UIImageView && self.bounds.size.height <= 1 {
            return (self as! UIImageView)
        }
        
        for subview in self.subviews {
            if let imageView = subview.findShadowImage() {
                return imageView
            }
        }
        
        return nil
    }
}
