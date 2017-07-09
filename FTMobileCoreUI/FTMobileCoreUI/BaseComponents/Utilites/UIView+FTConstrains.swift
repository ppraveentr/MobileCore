//
//  UIView+FTConstraint.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 08/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

extension CGRect {
    
    func getX() -> CGFloat {
        return self.origin.x
    }
    
    func getY() -> CGFloat {
        return self.origin.y
    }
    
    func getWidth() -> CGFloat {
        return self.size.width
    }
    
    func getHeight() -> CGFloat {
        return self.size.height
    }    
}

public struct EdgeOffsets {
    
    public var left: CGFloat
    
    public var right: CGFloat
    
    public var top: CGFloat
    
    public var bottom: CGFloat
    
    public init(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
    
    public static func EdgeOffsetsZero() -> EdgeOffsets {
        return EdgeOffsets(0, 0, 0, 0)
    }
    
    func getRight() -> CGFloat {
        return -self.right
    }
    
    func getBottom() -> CGFloat {
        return -self.bottom
    }
}

public struct FTEdgeInsets: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    public init(_ rawValue: UInt) { self.rawValue = rawValue }
    
    //View Margin
    public static let None = FTEdgeInsets(rawValue: 1 << 0)
    public static let Top = FTEdgeInsets(rawValue: 1 << 1)
    public static let Left = FTEdgeInsets(rawValue: 1 << 2)
    public static let Bottom = FTEdgeInsets(rawValue: 1 << 3)
    public static let Right = FTEdgeInsets(rawValue: 1 << 4)
    public static let Horizontal: FTEdgeInsets = [.Left, .Right]
    public static let Vertical: FTEdgeInsets = [.Top, .Bottom]
    public static let All: FTEdgeInsets = [.Horizontal, .Vertical]
    
    //Stacking View - Margin
    public static let LeadingMargin = FTEdgeInsets(rawValue: 1 << 5)
    public static let TrailingMargin = FTEdgeInsets(rawValue: 1 << 6)
    public static let TopMargin = FTEdgeInsets(rawValue: 1 << 7)
    public static let BottomMargin = FTEdgeInsets(rawValue: 1 << 8)
    public static let CenterMargin = FTEdgeInsets(rawValue: 1 << 9)
    public static let AutoMargin = FTEdgeInsets(rawValue: 1 << 10)
    
    //Stacking View - Size
    public static let EqualWidth = FTEdgeInsets(rawValue: 1 << 11)
    public static let EqualHeight = FTEdgeInsets(rawValue: 1 << 12)
}

public struct FTLayoutPriority {
    public let rawValue: CGFloat
    
    init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }
   
    public init(_ rawValue: CGFloat) {
        self.rawValue = rawValue
    }
    
    //View Priority
    public static let Required = FTLayoutPriority(rawValue: 1000.0)
    public static let High = FTLayoutPriority(rawValue: 750.0)
    public static let Low = FTLayoutPriority(rawValue: 250.0)
}

public enum FTLayoutDirection {
    case TopToBottom
    case RightToLeft
}

public extension UIView {
    
    public func pin(view : UIView, withEdgeOffsets edgeOffsets: EdgeOffsets = .EdgeOffsetsZero(), withEdgeInsets edgeInsets: FTEdgeInsets = .All, withLayoutPriority priority: FTLayoutPriority = .Required, addToSubView: Bool = true) {
        
        var hasSameBase = false
        
        if let superView = self.superview {
            if superView.subviews.contains(view) {
                hasSameBase = true
            }
        }
        
        if addToSubView && !self.subviews.contains(view) {
            self.addSubview(view)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var localConstraint = [NSLayoutConstraint]()
        
        var realtedBy: NSLayoutRelation = .equal
        if edgeInsets.contains(.AutoMargin) {
            realtedBy = .lessThanOrEqual
        }
        
        //Left
        if edgeInsets.contains(.Left) {
            
            var attribute: NSLayoutAttribute = .left
            if hasSameBase {
                attribute = .right
            }
            
            let leftCon = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1.0, constant: edgeOffsets.left)
            leftCon.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(leftCon)
        }
        
        //Right
        if edgeInsets.contains(.Right) {
            let leftCon = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: edgeOffsets.getRight())
            leftCon.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(leftCon)
        }
        
        //Top
        if edgeInsets.contains(.Top) {
            let leftCon = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: edgeOffsets.top)
            leftCon.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(leftCon)
        }
        
        //Bottom
        if edgeInsets.contains(.Bottom) {
            
            var attribute: NSLayoutAttribute = .bottom
            if hasSameBase {
                attribute = .top
            }
            
            let leftCon = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: edgeOffsets.getBottom())
            leftCon.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(leftCon)
        }
        
        //Leading
        if edgeInsets.contains(.LeadingMargin) && hasSameBase {
            let leftCon = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
            leftCon.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(leftCon)
        }
        
        //Traling
        if edgeInsets.contains(.TrailingMargin) && hasSameBase {
            let leftCon = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
            leftCon.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(leftCon)
        }
        
        if self.subviews.contains(view) {
            self.addConstraints(localConstraint)
        }
        else if hasSameBase {
            self.superview?.addConstraints(localConstraint)
        }
//        else if let superView = self.superview {
//            if superView.subviews.contains(view) {
//                superview?.addConstraints(constraints)
//            }
//        }
        
    }
    
    public func stackView(views: [UIView], withLayoutDirection direction: FTLayoutDirection = .TopToBottom, paddingBetween: CGFloat = 0, withEdgeOffsets edgeOffsets: EdgeOffsets = .EdgeOffsetsZero(), withEdgeInsets edgeInsets: FTEdgeInsets = .None) {
        
        var lastView: UIView? = nil
        
        for view in views {
            
            if !self.subviews.contains(view) {
                self.addSubview(view)
            }
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if direction == .TopToBottom {
                
                if (lastView != nil) {
                    lastView?.pin(view: view, withEdgeOffsets: EdgeOffsets(0, 0, 0, -paddingBetween), withEdgeInsets: [edgeInsets, .Bottom], addToSubView: false)
                }
                else if(edgeInsets.contains(.AutoMargin)) {
                    self.pin(view: view, withEdgeOffsets: edgeOffsets, withEdgeInsets: .Top, withLayoutPriority: .Low)
                }
                
            } else {
                
                if (lastView != nil) {
                    lastView?.pin(view: view, withEdgeOffsets: EdgeOffsets(paddingBetween, 0, 0, 0), withEdgeInsets: [edgeInsets, .Left], addToSubView: false)
                }
                else if(edgeInsets.contains(.AutoMargin)) {
                    self.pin(view: view, withEdgeOffsets: edgeOffsets, withEdgeInsets: .Left, withLayoutPriority: .Low)
                }
            }
            
            lastView = view
        }
        
        if (lastView != nil && edgeInsets.contains(.AutoMargin)) {
            
            if (direction == .TopToBottom) {
//                self.pin(view: lastView!, withEdgeOffsets: edgeOffsets, withEdgeInsets: .Bottom, withLayoutPriority: .Low, addToSubView: false)
            }
            else if (direction == .RightToLeft) {
//                self.pin(view: lastView!, withEdgeOffsets: edgeOffsets, withEdgeInsets: .Right, withLayoutPriority: .Low, addToSubView: false)
            }
        }
        
    }
    
}





























