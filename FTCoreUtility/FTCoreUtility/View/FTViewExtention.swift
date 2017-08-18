//
//  UIView+Utility.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 10/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIView {
    
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
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
}
