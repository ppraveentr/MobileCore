//
//  UIView+Utility.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 10/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation


extension UIView {
    
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
//    public class func fromNib(named name: String) -> Self? {
//        let allObjects = Bundle.main.loadNibNamed(name, owner: nil, options: nil) ?? []
//        return castFirst(allObjects)
//    }
//    
//    public class func fromNib() -> Self? {
//        return fromNib(named: className)
//    }
}
