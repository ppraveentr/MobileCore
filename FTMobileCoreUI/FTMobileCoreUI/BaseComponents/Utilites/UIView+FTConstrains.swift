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
    
    public static func EdgeOffsetsZero() -> EdgeOffsets { return EdgeOffsets(0, 0, 0, 0) }
    
    func getRight() -> CGFloat { return -self.right }
    
    func getBottom() -> CGFloat { return -self.bottom }
    
}

public enum FTLayoutDirection {
    case TopToBottom
    case LeftToRight
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
    }
}

public struct FTLayoutPriority {
    
    public let rawValue: CGFloat
    public init(_ rawValue: CGFloat) { self.rawValue = rawValue }
    
    //View Priority
    public static let Required = FTLayoutPriority(1000.0)
    public static let High = FTLayoutPriority(750.0)
    public static let Low = FTLayoutPriority(250.0)
}

public extension UIView {
    
    func hasSameBaseView(_ view: UIView) -> Bool {
        
        var hasSameBase = false

        if let superView = self.superview {
            
            if superView.subviews.contains(view) {
                hasSameBase = true
            }
            else if let baseView: FTBaseView = self.superview as? FTBaseView {
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
            let constraint = view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: edgeOffsets.left)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Right-Left Direction AutoMargin
        if edgeInsets.contains(.LeftRightMargin) {
            let constraint = view.leftAnchor.constraint(equalTo: self.rightAnchor, constant: edgeOffsets.left)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        if edgeInsets.contains(.LeftLayoutMargin) {
            //Top
            let constraintTop = view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            constraintTop.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraintTop)

            let constraint = view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Right
        if edgeInsets.contains(.Right) {
            let constraint = view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: edgeOffsets.getRight())
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Top
        if edgeInsets.contains(.Top) {
            let constraint = view.topAnchor.constraint(equalTo: self.topAnchor, constant: edgeOffsets.top)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Bottom
        if edgeInsets.contains(.Bottom) {
            let constraint = view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: edgeOffsets.getBottom())
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Top-Bottom Direction AutoMargin
        if edgeInsets.contains(.TopBottomMargin) {
            let constraint = view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: edgeOffsets.getBottom())
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        if edgeInsets.contains(.TopLayoutMargin) {
            let constraintTop = view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            constraintTop.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraintTop)
        }
        
        //CenterXMargin
        if edgeInsets.contains(.CenterXMargin) {
            let constraint = view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //CenterYMargin
        if edgeInsets.contains(.CenterYMargin) {
            let constraint = view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            constraint.priority = UILayoutPriority(priority.rawValue)
            localConstraint.append(constraint)
        }
        
        //Applicable for only Stacking
        if hasSameBase {
        
            //Leading
            if edgeInsets.contains(.LeadingMargin) {
                let constraint = view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //Traling
            if edgeInsets.contains(.TrailingMargin) {
                let constraint = view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
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
            if edgeInsets.contains(.BottomMargin) {
                let constraint = NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //Equal Height
            if edgeInsets.contains(.EqualHeight) {
                let constraint = view.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
                constraint.priority = UILayoutPriority(priority.rawValue)
                localConstraint.append(constraint)
            }
            
            //Equal Width
            if edgeInsets.contains(.EqualHeight) {
                let constraint = view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
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
    
    public func stackView(views: [UIView], withLayoutDirection direction: FTLayoutDirection = .LeftToRight, paddingBetween: CGFloat = 0, withEdgeInsets edgeInsets: FTEdgeInsets = .None, withLayoutPriority priority: FTLayoutPriority = .High) {
        
        var localEdgeInsets: FTEdgeInsets = edgeInsets
        localEdgeInsets.stanitize(forDirection: direction)
        
        var lastView: UIView? = nil
        
        for view in views {
            
            if !self.subviews.contains(view) {
                self.addSubview(view)
            }
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        for (index, view) in views.enumerated() {
            
            var offSet: EdgeOffsets = .EdgeOffsetsZero()
            
            if direction == .TopToBottom {
                offSet = EdgeOffsets(0, 0, 0, -paddingBetween)
                localEdgeInsets.update(with: .TopBottomMargin)

            } else {
                offSet = EdgeOffsets(paddingBetween, 0, 0, 0)
                localEdgeInsets.update(with: .LeftRightMargin)
            }
            
            if (lastView != nil) {
                lastView?.pin(view: view, withEdgeOffsets: offSet, withEdgeInsets: localEdgeInsets, withLayoutPriority: priority)
            }
            
            lastView = view

            if(localEdgeInsets.contains(.AutoMargin)) {
                
                //Fix to
                DispatchQueue.main.async {
                    let priority = FTLayoutPriority(CGFloat(views.count-index))
                    let defaultOffset = EdgeOffsets(paddingBetween)
                    
                    if direction == .TopToBottom {
                        self.pin(view: view, withEdgeOffsets: defaultOffset, withEdgeInsets: .TopLayoutMargin, withLayoutPriority: priority)
                    } else {
                        self.pin(view: view, withEdgeOffsets: defaultOffset, withEdgeInsets: .LeftLayoutMargin, withLayoutPriority: priority)
                    }
                }
                
                let pos = index + 1
                var localIndex = 0

                DispatchQueue.main.async {
                    
                    while (pos+localIndex < views.count) {
                        
                        let locallastView = views[localIndex]
                        let Preview = views[localIndex+pos]
                        localIndex = localIndex+1
                        
                        let priorityL = FTLayoutPriority(priority.rawValue - CGFloat(pos))
                        locallastView.pin(view: Preview, withEdgeOffsets: offSet, withEdgeInsets: localEdgeInsets, withLayoutPriority: priorityL)
                    }
                    
                }
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
