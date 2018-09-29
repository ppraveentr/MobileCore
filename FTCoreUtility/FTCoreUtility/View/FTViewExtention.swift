//
//  UIView+Utility.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 10/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIView {
    
    // Add 'contentView' as subView and pin the View to all edges
    public static func embedView(contentView: UIView) -> UIView {
        
        let local = self.init()
        local.backgroundColor = .clear
        
        local.pin(view: contentView, withEdgeInsets: [.All], withLayoutPriority: FTLayoutPriorityRequiredLow)
        local.pin(view: contentView, withEdgeInsets: [.CenterMargin], withLayoutPriority: .defaultLow)
        local.pin(view: contentView, withEdgeInsets: [.EqualWidth, .Top])
        
        return local
    }
    
    // Remove all subViews
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    // Remove all of its Constraints
    public func removeAllConstraints() {
        var cont: [NSLayoutConstraint] = self.constraints
        cont.removeAll()
    }
    
    // MARK: XIB
    // Get nib based on once's class name
    public static func getNIBFile() -> UINib? {
        return UINib(nibName: get_classNameAsString(obj: self) ?? "", bundle: nil)
    }
    
    // Get view based on once's class name
    public static func fromNib(_ owner: Any? = nil) -> UIView? {
        return fromNib(named: get_classNameAsString(obj: self) ?? "", owner: owner)
    }
    
    // Retruns first view from the nib file
    public static func fromNib(named name: String, owner: Any? = nil) -> UIView? {
        // Get all object inside the nib
        let allObjects = Bundle.main.loadNibNamed(name, owner: owner, options: nil) ?? []
        // Get first view object
        if let nib = allObjects.first as? UIView {
            return nib
        }
        
        return nil
    }
    
    // Add once's xib-view as subView
    public func xibSetup(className: UIView.Type) {
        var contentView : UIView?
        
        // Get view from nib
        contentView = className.fromNib(self)
        // Set contents tag as self'hash, just for unique identifiation
        contentView?.tag = self.hash
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }

    public func findInSubView<T>() -> T? {

        for val in ( self.subviews.compactMap { $0 } ) {
            if val is T {
                return val as? T
            } else if val.subviews.count > 0 {
                let subType: T? =  val.findInSubView()
                return subType
            }
        }
        return nil
    }
    
}

// Used for Bar items
public extension UIView {
    
    // Find all UIImageView with 'height <= 1'
    public func findShadowImage() -> [UIImageView]? {
        
        var imgs: [UIImageView] = []
        
        if self is UIImageView && self.bounds.height <= 1, let selfImamge = self as? UIImageView {
            return [selfImamge]
        }
        
        for subview in self.subviews {
            if
                let imageViews = subview.findShadowImage(),
                imageViews.count > 0 {
                imgs.append(contentsOf: imageViews)
            }
        }
        
        return imgs
    }
    
    // Remove all UIImageView's with 'height <= 1'
    public func hideShadowImage() {
        
        self.findShadowImage()?.forEach { (shadowImageView) in
            shadowImageView.isHidden = true
        }
    }
    
}
