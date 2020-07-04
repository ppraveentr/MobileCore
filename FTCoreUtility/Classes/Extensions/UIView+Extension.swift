//
//  UIView+Extension.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 10/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

// Screen width.
public var screenWidth: CGFloat {
    UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    UIScreen.main.bounds.height
}

public extension UIView {
    
    // MARK: XIB
    // Get nib based on once's class name
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
    
    // Get view based on once's class name
    static func fromNib(_ owner: Any? = nil) -> UIView? {
        fromNib(named: String(describing: self), owner: owner)
    }
    
    // Retruns first view from the nib file
    static func fromNib(named name: String, owner: Any? = nil) -> UIView? {
        // Get all object inside the nib
        let allObjects = Bundle(for: self).loadNibNamed(name, owner: owner, options: nil) ?? []
        // Get first view object
        if let nib = allObjects.first as? UIView {
            return nib
        }
        
        return nil
    }
    
    // Add once's xib-view as subView
    @discardableResult
    func xibSetup(className: UIView.Type) -> UIView? {

        // Get view from nib
        guard let contentView = className.fromNib(self) else {
            return nil
        }

        // Set contents tag as self'hash, just for unique identifiation
        contentView.tag = self.hash
        // use bounds not frame or it'll be offset
        contentView.frame = bounds
        // Make the view stretch with containing view
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView)
        // Retrun contentView
        return contentView
    }
    
    // Add 'contentView' as subView and pin the View to all edges
    static func embedView(contentView: UIView) -> UIView {
        let local = self.init()
        local.backgroundColor = .clear
        local.pin(view: contentView, edgeInsets: [.all], priority: kLayoutPriorityRequiredLow)
        local.pin(view: contentView, edgeInsets: [.centerMargin], priority: .defaultLow)
        local.pin(view: contentView, edgeInsets: [.equalWidth, .top])
        return local
    }
    
    // Remove all subViews
    func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    // Remove all of its Constraints
    func removeAllConstraints() {
        var cont: [NSLayoutConstraint] = self.constraints
        cont.removeAll()
    }
}
