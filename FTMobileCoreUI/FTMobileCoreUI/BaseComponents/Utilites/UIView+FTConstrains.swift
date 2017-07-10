//
//  UIView+FTConstraint.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 08/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

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

public enum FTLayoutDirection {
    case TopToBottom
    case RightToLeft
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
    public static let LeadingMargin = FTEdgeInsets(rawValue: 1 << 10)
    public static let TrailingMargin = FTEdgeInsets(rawValue: 1 << 11)
    public static let TopMargin = FTEdgeInsets(rawValue: 1 << 12)
    public static let BottomMargin = FTEdgeInsets(rawValue: 1 << 13)
    public static let CenterXMargin = FTEdgeInsets(rawValue: 1 << 14)
    public static let CenterYMargin = FTEdgeInsets(rawValue: 1 << 15)
    public static let CenterMargin: FTEdgeInsets = [.CenterXMargin, .CenterYMargin]
    public static let AutoMargin = FTEdgeInsets(rawValue: 1 << 17)
    
    //Stacking View - Size
    public static let EqualWidth = FTEdgeInsets(rawValue: 1 << 30)
    public static let EqualHeight = FTEdgeInsets(rawValue: 1 << 31)
    public static let EqualSize: FTEdgeInsets = [.EqualWidth, .EqualHeight]

    mutating func stanitize(forDirection direction: FTLayoutDirection){
        self.remove(.All)
        
        if direction == .TopToBottom {
            self.remove([.TopMargin, .BottomMargin])
            self.remove(.CenterYMargin)
            if self.contains(.CenterMargin) {
                self.remove(.CenterMargin)
                self.insert(.CenterXMargin)
            }
        }else{
            self.remove([.LeadingMargin, .TrailingMargin])
            self.remove(.CenterXMargin)
            if self.contains(.CenterMargin) {
                self.remove(.CenterMargin)
                self.insert(.CenterYMargin)
            }
        }
    }
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

public extension UIView {
    
    func hasSameBaseView(_ view: UIView) -> Bool {
        
        var hasSameBase = false

        if let superView = self.superview {
            
            if superView.subviews.contains(view) {
                hasSameBase = true
            }
            else if let baseView: FTBasePinnedView = self.superview as? FTBasePinnedView {
                if baseView.mainPinnedView.subviews.contains(view) {
                    hasSameBase = true
                }
            }
        }
        
        return hasSameBase
    }
    
    public func pin(view : UIView, withEdgeOffsets edgeOffsets: EdgeOffsets = .EdgeOffsetsZero(), withEdgeInsets edgeInsets: FTEdgeInsets = .All, withLayoutPriority priority: FTLayoutPriority = .Required, addToSubView: Bool = true) {
        
        let hasSameBase = self.hasSameBaseView(view)
        
        if (!self.subviews.contains(view) && !hasSameBase) {
            self.addSubview(view)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var localConstraint = [NSLayoutConstraint]()
        
        //Left
        if edgeInsets.contains(.Left) {
            
            var attribute: NSLayoutAttribute = .left
            if hasSameBase {
                attribute = .right
            }
            
            let constraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1.0, constant: edgeOffsets.left)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Right
        if edgeInsets.contains(.Right) {
            let constraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: edgeOffsets.getRight())
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Top
        if edgeInsets.contains(.Top) {
            let constraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: edgeOffsets.top)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Bottom
        if edgeInsets.contains(.Bottom) {
            
            var attribute: NSLayoutAttribute = .bottom
            if hasSameBase {
                attribute = .top
            }
            
            let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: edgeOffsets.getBottom())
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //CenterXMargin
        if edgeInsets.contains(.CenterXMargin) {
            let constraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //CenterYMargin
        if edgeInsets.contains(.CenterYMargin) {
            let constraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Applicable for only Stacking
        if hasSameBase {
        
            //Leading
            if edgeInsets.contains(.LeadingMargin) {
                let constraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //Traling
            if edgeInsets.contains(.TrailingMargin) {
                let constraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //TopMargin
            if edgeInsets.contains(.TopMargin) {
                let constraint = NSLayoutConstraint(item: view, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //BottomMargin
            if edgeInsets.contains(.TopMargin) {
                let constraint = NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //Equal Height
            if edgeInsets.contains(.EqualHeight) {
                let constraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //Equal Width
            if edgeInsets.contains(.EqualHeight) {
                let constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
        }
        
        if self.subviews.contains(view) {
            self.addConstraints(localConstraint)
        }
        else if hasSameBase {
            self.superview?.addConstraints(localConstraint)
        }
    }
    
    public func stackView(views: [UIView], withLayoutDirection direction: FTLayoutDirection = .TopToBottom, paddingBetween: CGFloat = 0, withEdgeInsets edgeInsets: FTEdgeInsets = .None, withLayoutPriority priority: FTLayoutPriority = .High) {
        
        var localEdgeInsets: FTEdgeInsets = edgeInsets
        localEdgeInsets.stanitize(forDirection: direction)
        
        var lastView: UIView? = nil
        
        for (index, view) in views.enumerated() {
            
            if !self.subviews.contains(view) {
                self.addSubview(view)
            }
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            var offSet: EdgeOffsets = .EdgeOffsetsZero()
            
            if direction == .TopToBottom {
                offSet = EdgeOffsets(0, 0, 0, -paddingBetween)
                localEdgeInsets.update(with: .Bottom)

            } else {
                offSet = EdgeOffsets(paddingBetween, 0, 0, 0)
                localEdgeInsets.update(with: .Left)
            }
            
            if (lastView != nil) {
                lastView?.pin(view: view, withEdgeOffsets: offSet, withEdgeInsets: localEdgeInsets, withLayoutPriority: priority)
            }
            
            lastView = view

            if(localEdgeInsets.contains(.AutoMargin)) {
                
                let priorityL = FTLayoutPriority(priority.rawValue  - CGFloat(index+1))

                DispatchQueue.main.async {
                    var subSet = views
                    subSet.remove(at: index)
                    self.subStack(views: subSet, withEdgeOffsets: offSet, withEdgeInsets: localEdgeInsets, withLayoutPriority: priorityL)
                }
                
                let priority = FTLayoutPriority(priority.rawValue - CGFloat(views.count) - CGFloat(index+1))
                
                if direction == .TopToBottom {
                    self.pin(view: view, withEdgeOffsets: offSet, withEdgeInsets: .Top, withLayoutPriority: priority)
                    
                } else {
                    self.pin(view: view, withEdgeOffsets: offSet, withEdgeInsets: .Right, withLayoutPriority: priority)
                }
            }
        }
    }
    
    private func subStack(views: [UIView], withEdgeOffsets edgeOffsets: EdgeOffsets, withEdgeInsets edgeInsets: FTEdgeInsets, withLayoutPriority priority: FTLayoutPriority) {
        
        DispatchQueue.main.async {
            
            var lastView: UIView? = nil
            
            for (index, view) in views.enumerated() {
                
                let priorityL = FTLayoutPriority(priority.rawValue - CGFloat(index+1))
                
                if (lastView != nil) {
                    lastView?.pin(view: view, withEdgeOffsets: edgeOffsets, withEdgeInsets: edgeInsets, withLayoutPriority: priorityL)
                }
                lastView = view
                
                var subSet = views
                subSet.remove(at: index)
                self.subStack(views: subSet, withEdgeOffsets: edgeOffsets, withEdgeInsets: edgeInsets, withLayoutPriority: priorityL)
            }
        }
    }
    
    
    public func addSizeConstraint(_ width: CGFloat, _ height: CGFloat){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if width >= 0 {
            let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
            self.addConstraint(constraint)
        }
        
        if height >= 0 {
            let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            self.addConstraint(constraint)
        }
    }
    
    public func addSelfSizing() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintWidth = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.layoutMargins.left + self.layoutMargins.right)
        self.addConstraint(constraintWidth)
        
        let constraintHeight = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.layoutMargins.bottom + self.layoutMargins.top)
        self.addConstraint(constraintHeight)
    }
}

//private extension UIView {
//
//    private struct AssociatedKey {
//        static var constrainsPrevoiusViewKey = "constrainsPrevoiusViewKey"
//        static var constrainsNextViewKey = "constrainsNextViewKey"
//    }
//    
//    var previousView: UIView? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKey.constrainsPrevoiusViewKey) as? UIView
//        }
//        set {
//            if let view = newValue {
//                objc_setAssociatedObject(self, &AssociatedKey.constrainsPrevoiusViewKey, view, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
//            }
//        }
//    }
//    
//    var nextView: UIView? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKey.constrainsPrevoiusViewKey) as? UIView
//        }
//        set {
//            if let view = newValue {
//                objc_setAssociatedObject(self, &AssociatedKey.constrainsPrevoiusViewKey, view, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
//            }
//        }
//    }
//}
//
