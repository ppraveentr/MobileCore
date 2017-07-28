//
//  UIView+FTConstraint.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 08/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

@objc public protocol FTSubViewProtocal {
    @objc optional func getBaseView() -> UIView
}

public enum FTLayoutDirection {
    case TopToBottom
    case LeftToRight
}

public struct FTEdgeOffsets {
    
    public var left: CGFloat
    public var top: CGFloat
    public var right: CGFloat
    public var bottom: CGFloat
    
    public init(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
    
    public init(_ padding: CGFloat) {
        self.left = padding
        self.top = padding
        self.right = padding
        self.bottom = padding
    }
    
    public static func FTEdgeOffsetsZero() -> FTEdgeOffsets { return FTEdgeOffsets(0, 0, 0, 0) }
    
    func getRight() -> CGFloat { return -self.right }
    
    func getBottom() -> CGFloat { return -self.bottom }
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
    
    fileprivate static let TopLayoutMargin = FTEdgeInsets(rawValue: 1 << 20)
    fileprivate static let LeftLayoutMargin = FTEdgeInsets(rawValue: 1 << 21)
    fileprivate static let TopBottomMargin = FTEdgeInsets(rawValue: 1 << 22)
    fileprivate static let LeftRightMargin = FTEdgeInsets(rawValue: 1 << 23)

    //Stacking View - Size
    public static let EqualWidth = FTEdgeInsets(rawValue: 1 << 30)
    public static let EqualHeight = FTEdgeInsets(rawValue: 1 << 31)
    public static let EqualSize: FTEdgeInsets = [.EqualWidth, .EqualHeight]
    public static let AutoSize = FTEdgeInsets(rawValue: 1 << 32)

    
    //Remove inValid Constrains
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
        
        if self.contains(.AutoMargin) {
            self.update(with: .AutoSize)
        }
    }
}

extension UIView: FTSubViewProtocal {}

public extension UIView {
    
    func hasSameBaseView(_ view: UIView) -> Bool {
        
        var hasSameBase = false

        if let superView = self.superview {
            
            if superView.subviews.contains(view) {
                
                hasSameBase = true
                
            } else if
                let subView = superView as FTSubViewProtocal?,
                let baseView: UIView = subView.getBaseView?() {
                
                    if baseView.subviews.contains(view) {
                        hasSameBase = true
                    }
                }
        }
        
        return hasSameBase
    }
    
    public func pin(view : UIView, withEdgeOffsets FTEdgeOffsets: FTEdgeOffsets = .FTEdgeOffsetsZero(),
                    withEdgeInsets edgeInsets: FTEdgeInsets = .All,
                    withLayoutPriority priority: UILayoutPriority = UILayoutPriorityRequired, addToSubView: Bool = true) {
        
        var priority = priority
        if priority < 0  {
            priority = 1
        } else if priority > UILayoutPriorityRequired  {
            priority = UILayoutPriorityRequired
        }
        
        let hasSameBase = self.hasSameBaseView(view)
        
        if (addToSubView && !self.subviews.contains(view) && !hasSameBase) {
            self.addSubview(view)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var localConstraint = [NSLayoutConstraint]()
        
        //Left
        if edgeInsets.contains(.Left) {
            let constraint = view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: FTEdgeOffsets.left)
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        //Right-Left Direction AutoMargin
        if edgeInsets.contains(.LeftRightMargin) {
            let constraint = view.leftAnchor.constraint(equalTo: self.rightAnchor, constant: FTEdgeOffsets.left)
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        if edgeInsets.contains(.LeftLayoutMargin) {
            //Top
            let constraintTop = view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            constraintTop.priority = priority
            localConstraint.append(constraintTop)

            let constraint = view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: FTEdgeOffsets.left)
            constraint.priority = priority
            localConstraint.append(constraint)
            
            let constraintRight = view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: FTEdgeOffsets.getRight())
            constraintRight.priority = priority
            localConstraint.append(constraintRight)
        }
        
        //Right
        if edgeInsets.contains(.Right) {
            let constraint = view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: FTEdgeOffsets.getRight())
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        //Top
        if edgeInsets.contains(.Top) {
            let constraint = view.topAnchor.constraint(equalTo: self.topAnchor, constant: FTEdgeOffsets.top)
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        //Bottom
        if edgeInsets.contains(.Bottom) {
            let constraint = view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: FTEdgeOffsets.getBottom())
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        //Top-Bottom Direction AutoMargin
        if edgeInsets.contains(.TopBottomMargin) {
            let constraint = view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: FTEdgeOffsets.getBottom())
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        if edgeInsets.contains(.TopLayoutMargin) {
            let constraintTop = view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            constraintTop.priority = priority
            localConstraint.append(constraintTop)
            
            let constraintBottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            constraintBottom.priority = priority
            localConstraint.append(constraintTop)

        }
        
        //CenterXMargin
        if edgeInsets.contains(.CenterXMargin) {
            let constraint = view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        //CenterYMargin
        if edgeInsets.contains(.CenterYMargin) {
            let constraint = view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        //Auto Sizing
        if edgeInsets.contains(.AutoSize) {
           view.addSelfSizing()
        }
        
        //Applicable for only Stacking
//        if hasSameBase {
        
            //Leading
            if edgeInsets.contains(.LeadingMargin) {
                let constraint = view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
                constraint.priority = priority
                localConstraint.append(constraint)
            }
            
            //Traling
            if edgeInsets.contains(.TrailingMargin) {
                let constraint = view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
                constraint.priority = priority
                localConstraint.append(constraint)
            }
            
            //TopMargin
            if edgeInsets.contains(.TopMargin) {
                let constraint = NSLayoutConstraint(item: view, attribute: .topMargin, relatedBy: .equal, toItem: self,
                                                    attribute: .topMargin, multiplier: 1.0, constant: 0)
                constraint.priority = priority
                localConstraint.append(constraint)
            }
            
            //BottomMargin
            if edgeInsets.contains(.BottomMargin) {
                let constraint = NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal,
                                                    toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 0)
                constraint.priority = priority
                localConstraint.append(constraint)
            }
            
            //Equal Height
            if edgeInsets.contains(.EqualHeight) {
                let constraint = view.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
                constraint.priority = priority
                localConstraint.append(constraint)
            }
            
            //Equal Width
            if edgeInsets.contains(.EqualHeight) {
                let constraint = view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
                constraint.priority = priority
                localConstraint.append(constraint)
            }
//        }
        
        if self.subviews.contains(view) || !addToSubView {
            self.addConstraints(localConstraint)
        }
        else if hasSameBase {
            self.superview?.addConstraints(localConstraint)
        }
    }
    
    public func stackView(views: [UIView], withLayoutDirection direction: FTLayoutDirection = .TopToBottom,
                          paddingBetween: CGFloat = 0, withEdgeInsets edgeInsets: FTEdgeInsets = .None,
                          withLayoutPriority priority: UILayoutPriority = UILayoutPriorityRequired) {
        
        //Add views to subView, if not present
        views.forEach { (view) in
            
            if !self.subviews.contains(view) {
                self.addSubview(view)
            }
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //Pin each view to self with Default-padding, with lower priority.
        //Used of .AutoMargin edgeInsets, 
        //If any view is removed, this will reset the remaningViews to defaults
        let pinEachView = { (index: Int, view: UIView) in
            
            //Fix to
            let priorityL = priority - Float(views.count + index)
            let defaultOffset = FTEdgeOffsets(paddingBetween)
            
            if direction == .TopToBottom {
                self.pin(view: view, withEdgeOffsets: defaultOffset, withEdgeInsets: .TopLayoutMargin,
                         withLayoutPriority: priorityL)
            } else {
                self.pin(view: view, withEdgeOffsets: defaultOffset, withEdgeInsets: .LeftLayoutMargin,
                         withLayoutPriority: priorityL)
            }
        }
        
        //Pin each view to nextView with zeroOffSet-paddingBetween, with lower priority.
        //Used of .AutoMargin edgeInsets,
        //If any view is removed, this will reset the remaningViews to defaults
        let pairSubViews = { (index: Int, offSet: FTEdgeOffsets, subEdgeInsets: FTEdgeInsets) in
            
            let pos = index + 1
            var localIndex = 0
            
            while (pos+localIndex < views.count) {
                
                let locallastView = views[localIndex]
                let Preview = views[localIndex+pos]
                localIndex = localIndex+1
                
                let priorityS = priority - Float(pos)
                locallastView.pin(view: Preview, withEdgeOffsets: offSet, withEdgeInsets: subEdgeInsets,
                                  withLayoutPriority: priorityS)
            }
        }
        
        //For Each View
        var localEdgeInsets: FTEdgeInsets = edgeInsets
        localEdgeInsets.stanitize(forDirection: direction)
        
        var lastView: UIView? = nil
        
        views.enumerated().forEach { (index, view) in
            
            var offSet: FTEdgeOffsets = .FTEdgeOffsetsZero()
            
            if direction == .TopToBottom {
                offSet = FTEdgeOffsets(0, 0, 0, -paddingBetween)
                localEdgeInsets.update(with: .TopBottomMargin)
                
            } else {
                offSet = FTEdgeOffsets(paddingBetween, 0, 0, 0)
                localEdgeInsets.update(with: .LeftRightMargin)
            }
            
            if (lastView != nil) {
                lastView?.pin(view: view, withEdgeOffsets: offSet, withEdgeInsets: localEdgeInsets,
                              withLayoutPriority: priority)
            }
            
            lastView = view
            
            if(localEdgeInsets.contains(.AutoMargin)) {
                
                //Pin each view to self with Default-padding.
                pinEachView(index, view)
                
                //Pin each view to nextView with offSet-padding.
                pairSubViews(index, offSet, localEdgeInsets)
            }
        }
    }
    
    //Sets height & width of the View
    //Negative values will skip setting constraints
    //If invoked after ".AutoSize or addSelfSizing", the view will not auto-resize the width & height.
    public func addSizeConstraint(_ width: CGFloat = -10, _ height: CGFloat = -10){
        
        self.viewLayoutConstraint.autoSizing = false

        self.translatesAutoresizingMaskIntoConstraints = false
        
        if width >= 0 {
            self.setViewWidth(width, createConstraint: true)
        }
        
        if height >= 0 {
            self.setViewHeight(height, createConstraint: true)
        }
    }
    
    //Auto-size to self height and width
    public func addSelfSizing() {
        
        self.viewLayoutConstraint.autoSizing = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setViewWidth(self.layoutMargins.left - self.layoutMargins.right)
        self.setViewHeight(self.layoutMargins.top - self.layoutMargins.bottom)
        
        self.sizeToFit()
    }
    
    //All Produces Positive Screen offset size
    func resizeToFitSubviewsInScreen() {

        let subviewsRect = subviews.reduce(CGRect.zero) {
            $0.union($1.frame)
        }

        let fix = subviewsRect.origin
        subviews.forEach {
            $0.frame.offsetBy(dx: -fix.x, dy: -fix.y)
        }

        frame.offsetBy(dx: fix.x, dy: fix.y)
        frame.size = subviewsRect.size
        
        self.setViewSize(subviewsRect.size)
    }
    
    //Incudes Negative screen offset
    func  resizeToFitSubviews() {
        
        let reducedSize = subviews.reduce(CGSize.zero) { (point, view) -> CGSize in
            return CGSize(width: max(point.width, view.frame.maxX), height: max(point.height, view.frame.maxY))
        }
        
        //if screen size changes, update layout again
        if !self.frame.size.equalTo(reducedSize) {
         
            self.frame.size = reducedSize
            self.setViewSize(reducedSize)
            
            //Update Screen layout
            DispatchQueue.main.async {
                self.superview?.setNeedsLayout()
                self.superview?.layoutIfNeeded()
            }
        }
    }
}

//AssociatedObject for view Layout constraints
public class FTViewLayoutConstraint {
    
    public var autoSizing = false
    
    public var constraintWidth: NSLayoutConstraint?
    public var constraintHeight: NSLayoutConstraint?
}

fileprivate var kFTlayoutAssociationKey: UInt8 = 0

public extension UIView {
    
    public var viewLayoutConstraint: FTViewLayoutConstraint {
        get {
            if let storedLayouts = objc_getAssociatedObject(self, &kFTlayoutAssociationKey) as? FTViewLayoutConstraint {
                return storedLayouts
            }
            
            self.viewLayoutConstraint = FTViewLayoutConstraint()
            return self.viewLayoutConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kFTlayoutAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setViewSize(_ size: CGSize, createConstraint: Bool = false) {
        self.setViewHeight(size.height, createConstraint: createConstraint)
        self.setViewWidth(size.width, createConstraint: createConstraint)
    }
    
    public func setViewHeight(_ height: CGFloat, createConstraint: Bool = false) {
        
        if createConstraint || self.viewLayoutConstraint.autoSizing {
            let con = self.viewLayoutConstraint
            
            if con.constraintHeight == nil {
                con.constraintHeight =  self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
                con.constraintHeight?.isActive = true
            }else {
                con.constraintHeight?.constant = height
            }
        }
    }
    
    public func setViewWidth(_ width: CGFloat, createConstraint: Bool = false) {
        
        if createConstraint || self.viewLayoutConstraint.autoSizing {
            let con = self.viewLayoutConstraint
            
            if con.constraintWidth == nil {
                con.constraintWidth =  self.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
                con.constraintWidth?.isActive = true
            }else {
                con.constraintWidth?.constant = width
            }
        }
    }
}
