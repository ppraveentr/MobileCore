//
//  ViewLayoutConstraint.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 08/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

// UILayoutPriority value little lessThan .required
public let kLayoutPriorityRequiredLow = UILayoutPriority(UILayoutPriority.required.rawValue - 1)

public enum LayoutDirection {
    case topToBottom
    case leftToRight
}

// MARK: AssociatedObject for view Layout constraints
public class ViewLayoutConstraint {
    public var autoSizing = false
    public var constraintWidth: NSLayoutConstraint?
    public var constraintHeight: NSLayoutConstraint?
    public var heightDimension: NSLayoutDimension?
    public var widthDimension: NSLayoutDimension?
}

public extension UIEdgeInsets {
    init(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    init(_ padding: CGFloat) {
        self.init(top: padding, left: padding, bottom: -padding, right: -padding)
    }
}

public struct EdgeInsets: OptionSet {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) { self.rawValue = rawValue }
    public init(_ rawValue: UInt) { self.rawValue = rawValue }
    
    // View Margin
    public static let none = EdgeInsets(1 << 0)
    public static let top = EdgeInsets(1 << 1)
    public static let left = EdgeInsets(1 << 2)
    public static let bottom = EdgeInsets(1 << 3)
    public static let right = EdgeInsets(1 << 4)
    public static let horizontal: EdgeInsets = [.left, .right]
    public static let vertical: EdgeInsets = [.top, .bottom]
    public static let all: EdgeInsets = [.horizontal, .vertical]
    
    // Stacking View - Margin
    public static let leadingMargin = EdgeInsets(1 << 5)
    public static let trailingMargin = EdgeInsets(1 << 6)
    public static let topMargin = EdgeInsets(1 << 7)
    public static let bottomMargin = EdgeInsets(1 << 8)
    public static let centerXMargin = EdgeInsets(1 << 9)
    public static let centerYMargin = EdgeInsets(1 << 10)
    public static let centerMargin: EdgeInsets = [.centerXMargin, .centerYMargin]
    public static let autoMargin = EdgeInsets(1 << 11)
    
    // Private
//    fileprivate static let AllLayoutMargin: FTEdgeInsets = [.LeadingMargin, .TrailingMargin,
//                                                            .TopMargin, .BottomMargin,
//                                                            .CenterMargin, .AutoMargin]

    fileprivate static let topLayoutMargin = EdgeInsets(1 << 12)
    fileprivate static let leftLayoutMargin = EdgeInsets(1 << 13)
    fileprivate static let topBottomMargin = EdgeInsets(1 << 14)
    fileprivate static let leftRightMargin = EdgeInsets(1 << 15)

    // Stacking View - Size
    public static let equalWidth = EdgeInsets(1 << 16)
    public static let equalHeight = EdgeInsets(1 << 17)
    public static let equalSize: EdgeInsets = [.equalWidth, .equalHeight]
    // Note: 'autoSize', should be only used if we are stacking View, 
    // else if used in normal 'pin' UI will break.
    public static let autoSize = EdgeInsets(1 << 18)

    // Remove inValid Constrains
    mutating func stanitize(forDirection direction: LayoutDirection) {
        self.remove(.all)
        
        if direction == .topToBottom {
            self.remove([.topMargin, .bottomMargin])
            self.remove(.centerYMargin)
            if self.contains(.centerMargin) {
                self.remove(.centerMargin)
                self.insert(.centerXMargin)
            }
        }
        else {
            self.remove([.leadingMargin, .trailingMargin])
            self.remove(.centerXMargin)
            if self.contains(.centerMargin) {
                self.remove(.centerMargin)
                self.insert(.centerYMargin)
            }
        }
        
        // autoMargin, needs to have equalSize to adjust sizing
        if self.contains(.autoMargin) {
            // FIXIT: Update to remove .EqualSize
            self.update(with: .equalSize)
            self.update(with: .autoSize)
        }
    }
}

public protocol ViewConstrains: AnyObject {
    
    func pin(view: UIView,
             withEdgeOffsets edgeOffsets: UIEdgeInsets?,
             withEdgeInsets edgeInsets: EdgeInsets?,
             withLayoutPriority priority: UILayoutPriority?,
             addToSubView: Bool?
    )
    
    func stackView(views: [UIView],
                   layoutDirection direction: LayoutDirection,
                   spacing: CGFloat,
                   edgeInsets: EdgeInsets?,
                   layoutPriority priority: UILayoutPriority?)
    
    func addSizeConstraint(_ width: CGFloat, _ height: CGFloat)
    
    // auto-size to self height and width
    func addSelfSizing()
    
    // Incudes Negative screen offset
    func resizeToFitSubviews()
    
    func setViewSize(_ size: CGSize, createConstraint: Bool, relation: NSLayoutConstraint.Relation)
    
    func setViewHeight(_ height: CGFloat, createConstraint: Bool, relation: NSLayoutConstraint.Relation)
    
    func setViewWidth(_ width: CGFloat, createConstraint: Bool, relation: NSLayoutConstraint.Relation)
}

public extension UIView {
    func pin<Anchor, AnchorType>(_ anchorPath: KeyPath<UIView, Anchor>,
                                 toView view: UIView,
                                 priority: UILayoutPriority,
                                 constant: CGFloat = 0) -> NSLayoutConstraint
        where Anchor: NSLayoutAnchor<AnchorType> {
            let constraint = view[keyPath: anchorPath].constraint(equalTo: self[keyPath: anchorPath], constant: constant)
            constraint.priority = priority
            return constraint
    }
}

private extension UIView {
    func hasSameBaseView(_ view: UIView) -> Bool {
        self.superview?.subviews.contains(view) ?? false
    }
    
    func validPriority(_ priority: UILayoutPriority) -> UILayoutPriority {
        if Int(priority.rawValue) < 0 {
            return UILayoutPriority(rawValue: 1)
        }
        else if priority.rawValue > UILayoutPriority.required.rawValue {
            return .required
        }
        return priority
    }
    
    func pinEdges(view: UIView, edgeOffsets: UIEdgeInsets, edgeInsets: EdgeInsets, priority: UILayoutPriority) -> [NSLayoutConstraint] {
        var localConstraint = [NSLayoutConstraint]()
        
        // Left
        if edgeInsets.contains(.left) {
            let constraint = self.pin(\UIView.leftAnchor, toView: view, priority: priority, constant: edgeOffsets.left)
            localConstraint.append(constraint)
        }
        
        // Right
        if edgeInsets.contains(.right) {
            let constraint = self.pin(\UIView.rightAnchor, toView: view, priority: priority, constant: edgeOffsets.right)
            localConstraint.append(constraint)
        }
        
        // Top
        if edgeInsets.contains(.top) {
            let constraint = self.pin(\UIView.topAnchor, toView: view, priority: priority, constant: edgeOffsets.top)
            localConstraint.append(constraint)
        }
        
        // Bottom
        if edgeInsets.contains(.bottom) {
            let constraint = self.pin(\UIView.bottomAnchor, toView: view, priority: priority, constant: edgeOffsets.bottom)
            localConstraint.append(constraint)
        }
        
        return localConstraint
    }
    
    func pinMargin(view: UIView, edgeOffsets: UIEdgeInsets, edgeInsets: EdgeInsets, priority: UILayoutPriority) -> [NSLayoutConstraint] {
        
        var localConstraint = [NSLayoutConstraint]()
        
        // Top Margin
        if edgeInsets.contains(.topLayoutMargin) {
            let constraintTop = self.pin(\UIView.topAnchor, toView: view, priority: priority)
            localConstraint.append(constraintTop)
            
            let constraintBottom = self.pin(\UIView.bottomAnchor, toView: view, priority: priority)
            localConstraint.append(constraintBottom)
        }
        
        // Left Margin
        if edgeInsets.contains(.leftLayoutMargin) {
            let constraint = self.pin(\UIView.leftAnchor, toView: view, priority: priority, constant: edgeOffsets.left)
            localConstraint.append(constraint)
            
            let constraintRight = self.pin(\UIView.rightAnchor, toView: view, priority: priority, constant: edgeOffsets.right)
            localConstraint.append(constraintRight)
        }
        
        // CenterXMargin
        if edgeInsets.contains(.centerXMargin) {
            let constraint = self.pin(\UIView.centerXAnchor, toView: view, priority: priority)
            localConstraint.append(constraint)
        }
        
        // CenterYMargin
        if edgeInsets.contains(.centerYMargin) {
            let constraint = self.pin(\UIView.centerYAnchor, toView: view, priority: priority)
            localConstraint.append(constraint)
        }
        
        return localConstraint
    }
    
    func pinAutoMargin(view: UIView, edgeOffsets: UIEdgeInsets, edgeInsets: EdgeInsets, priority: UILayoutPriority) -> [NSLayoutConstraint] {
        var localConstraint = [NSLayoutConstraint]()
        
        // Right-Left Direction AutoMargin
        if edgeInsets.contains(.leftRightMargin) {
            let constraint = view.leftAnchor.constraint(equalTo: self.rightAnchor, constant: edgeOffsets.left)
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        // Top-Bottom Direction AutoMargin
        if edgeInsets.contains(.topBottomMargin) {
            let constraint = view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: edgeOffsets.bottom)
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        return localConstraint
    }
    
    func pinStackViewMargin(view: UIView, edgeInsets: EdgeInsets, priority: UILayoutPriority) -> [NSLayoutConstraint] {
        var localConstraint = [NSLayoutConstraint]()
        
        // Leading
        if edgeInsets.contains(.leadingMargin) {
            let constraint = self.pin(\UIView.leadingAnchor, toView: view, priority: priority)
            localConstraint.append(constraint)
        }
        
        // Traling
        if edgeInsets.contains(.trailingMargin) {
            let constraint = self.pin(\UIView.trailingAnchor, toView: view, priority: priority)
            localConstraint.append(constraint)
        }
        
        // TopMargin
        if edgeInsets.contains(.topMargin) {
            let constraint = NSLayoutConstraint(
                item: view,
                attribute: .topMargin,
                relatedBy: .equal,
                toItem: self,
                attribute: .topMargin,
                multiplier: 1.0,
                constant: 0
            )
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        // BottomMargin
        if edgeInsets.contains(.bottomMargin) {
            let constraint = NSLayoutConstraint(
                item: view,
                attribute: .bottomMargin,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottomMargin,
                multiplier: 1.0,
                constant: 0
            )
            constraint.priority = priority
            localConstraint.append(constraint)
        }
        
        // Equal Height
        if edgeInsets.contains(.equalHeight) {
            let constraint = self.pin(\UIView.heightAnchor, toView: view, priority: priority, constant: 0)
            localConstraint.append(constraint)
        }
        
        // Equal Width
        if edgeInsets.contains(.equalWidth) {
            let constraint = self.pin(\UIView.widthAnchor, toView: view, priority: priority, constant: 0)
            localConstraint.append(constraint)
        }
        
        return localConstraint
    }
}

public extension UIView {
    
    func pin(view: UIView,
             edgeOffsets: UIEdgeInsets = .zero,
             edgeInsets: EdgeInsets = .all,
             priority: UILayoutPriority = .required,
             addToSubView: Bool = true) {
        
        var localConstraint = [NSLayoutConstraint]()
        let priority = validPriority(priority)
        let hasSameBase = self.hasSameBaseView(view)
        
        if addToSubView && !self.subviews.contains(view) && !hasSameBase {
            self.addSubview(view)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // pin Edges: Left, Right, Top, Bottom
        let edges = pinEdges(view: view, edgeOffsets: edgeOffsets, edgeInsets: edgeInsets, priority: priority)
        localConstraint.append(contentsOf: edges)
        
        // pin Margin: Top, Bottom, Center-X&Y,
        let margins = pinMargin(view: view, edgeOffsets: edgeOffsets, edgeInsets: edgeInsets, priority: priority)
        localConstraint.append(contentsOf: margins)
        
        // pin Margin: Right-Left, Top-Bottom
        let autoMargin = pinAutoMargin(view: view, edgeOffsets: edgeOffsets, edgeInsets: edgeInsets, priority: priority)
        localConstraint.append(contentsOf: autoMargin)
        
        // Auto Sizing
        if edgeInsets.contains(.autoSize) {
           view.addSelfSizing()
        }
        
        // Applicable for only Stacking, only if hasSameBase
        let stackingMargin = pinStackViewMargin(view: view, edgeInsets: edgeInsets, priority: priority)
        localConstraint.append(contentsOf: stackingMargin)
        
        // Add created Constraints to view
        if self.subviews.contains(view) || !addToSubView {
            self.addConstraints(localConstraint)
        }
        else if hasSameBase {
            self.superview?.addConstraints(localConstraint)
        }
    }
    
    func stackView(views: [UIView],
                   layoutDirection direction: LayoutDirection = .topToBottom,
                   spacing: CGFloat = 0,
                   edgeInsets: EdgeInsets = .none,
                   layoutPriority priority: UILayoutPriority = UILayoutPriority.required
        ) {
        // Add views to subView, if not present
        views.filter { !self.subviews.contains($0) }.forEach(addSubview(_:))
        
        // Pin each view to self with Default-padding, with lower priority.
        // Used of .AutoMargin edgeInsets, 
        // If any view is removed, this will reset the remaningViews to defaults
        let pinEachViewToSuperView = { (index: Int, view: UIView) in
            // Fix to
            let priorityL = priority.rawValue - Float(views.count + index)
            let defaultOffset = UIEdgeInsets(0)
            
            if direction == .topToBottom {
                self.pin(view: view, edgeOffsets: defaultOffset, edgeInsets: .topLayoutMargin, priority: UILayoutPriority(rawValue: priorityL))
            }
            else {
                self.pin(view: view, edgeOffsets: defaultOffset, edgeInsets: .leftLayoutMargin, priority: UILayoutPriority(rawValue: priorityL))
            }
        }
        
        // Pin each view to nextView with zeroOffSet-spacing, with lower priority.
        // Used of .AutoMargin edgeInsets,
        // If any view is removed, this will reset the remaningViews to defaults
        let pinPairSubViews = { (index: Int, offSet: UIEdgeInsets, subEdgeInsets: EdgeInsets) in
            
            let pos = index + 1
            var localIndex = 0
            
            while pos + localIndex < views.count {
                let locallastView = views[localIndex]
                let preview = views[localIndex + pos]
                localIndex += 1
                
                let priorityS = priority.rawValue - Float(pos)
                locallastView.pin(
                    view: preview,
                    edgeOffsets: offSet,
                    edgeInsets: subEdgeInsets,
                    priority: UILayoutPriority(rawValue: priorityS)
                )
            }
        }
        
        // For Each View
        var localEdgeInsets: EdgeInsets = edgeInsets
        localEdgeInsets.stanitize(forDirection: direction)

        var lastView: UIView?
        
        var offSet: UIEdgeInsets = .zero
        
        if direction == .topToBottom {
            offSet = UIEdgeInsets(0, 0, 0, -spacing)
            localEdgeInsets.update(with: .topBottomMargin)
        }
        else {
            offSet = UIEdgeInsets(spacing, 0, 0, 0)
            localEdgeInsets.update(with: .leftRightMargin)
        }
        
        views.enumerated().forEach { index, view in
            
            view.translatesAutoresizingMaskIntoConstraints = false

            if lastView != nil {
                lastView?.pin(view: view, edgeOffsets: offSet, edgeInsets: localEdgeInsets, priority: priority)
            }
            
            lastView = view
            
            // TODO: Simplfy the logic
            if localEdgeInsets.contains(.autoMargin) {
                // Pin each view to self with Default-padding.
                pinEachViewToSuperView(index, view)
                
                // Pin each view to nextView with offSet-padding.
                pinPairSubViews(index, offSet, localEdgeInsets)
            }
        }
    }
    
    // Sets height & width of the View
    // Negative values will skip setting constraints
    // If invoked after ".autoSize or addSelfSizing", the view will not auto-resize the width & height.
    func addSizeConstraint(_ width: CGFloat = -10, _ height: CGFloat = -10, relation: NSLayoutConstraint.Relation = .equal) {
        self.viewLayoutConstraint.autoSizing = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if width >= 0 {
            self.setViewWidth(width, createConstraint: true, relation: relation)
        }
        
        if height >= 0 {
            self.setViewHeight(height, createConstraint: true, relation: relation)
        }
    }
    
    // Auto-size to self height and width
    func addSelfSizing() {
        self.viewLayoutConstraint.autoSizing = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setViewWidth(self.layoutMargins.left - self.layoutMargins.right)
        self.setViewHeight(self.layoutMargins.top - self.layoutMargins.bottom)
        self.sizeToFit()
    }
    
    // Incudes Negative screen offset
    func resizeToFitSubviews() {
        let reducedSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // if screen size changes, update layout again
        if !self.frame.size.equalTo(reducedSize) {
            self.frame.size = reducedSize
            self.setViewSize(reducedSize, relation: .equal)
        }
    }
    
    // MARK: AssociatedObject for view Layout constraints
    fileprivate static let aoLayoutConstraint = AssociatedObject<ViewLayoutConstraint>()
    
    var viewLayoutConstraint: ViewLayoutConstraint {
        get {
            if let storedLayouts = UIView.aoLayoutConstraint[self] {
                return storedLayouts
            }
            
            self.viewLayoutConstraint = ViewLayoutConstraint()
            return self.viewLayoutConstraint
        }
        set {
            UIView.aoLayoutConstraint[self] = newValue
        }
    }
    
    func setViewSize(_ size: CGSize, createConstraint: Bool = false, relation: NSLayoutConstraint.Relation = .greaterThanOrEqual) {
        self.setViewHeight(size.height, createConstraint: createConstraint, relation: relation)
        self.setViewWidth(size.width, createConstraint: createConstraint, relation: relation)
    }
    
    func setViewHeight(_ height: CGFloat, createConstraint: Bool = false, relation: NSLayoutConstraint.Relation = .greaterThanOrEqual) {
       let con = self.viewLayoutConstraint
        if createConstraint || con.autoSizing {
            if con.constraintHeight == nil || (createConstraint && con.constraintHeight?.relation != relation) {
                con.heightDimension = self.heightAnchor
                
                switch relation {
                case .equal:
                    con.constraintHeight = self.heightAnchor.constraint(equalToConstant: height)
                case .lessThanOrEqual:
                    con.constraintHeight = self.heightAnchor.constraint(lessThanOrEqualToConstant: height)
                default:
                    con.constraintHeight = self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
                }
                con.constraintHeight?.isActive = true
            }
            else {
                con.constraintHeight?.constant = height
            }
        }
    }
    
    func setViewWidth(_ width: CGFloat, createConstraint: Bool = false, relation: NSLayoutConstraint.Relation = .greaterThanOrEqual) {
        let con = self.viewLayoutConstraint
        if createConstraint || con.autoSizing {
            if con.constraintWidth == nil || (createConstraint && con.constraintWidth?.relation != relation) {
                con.widthDimension = self.widthAnchor
                switch relation {
                case .equal:
                    con.constraintWidth = self.widthAnchor.constraint(equalToConstant: width)
                case .lessThanOrEqual:
                    con.constraintWidth = self.widthAnchor.constraint(lessThanOrEqualToConstant: width)
                default:
                    con.constraintWidth = self.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
                }
                con.constraintWidth?.isActive = true
            }
            else {
                con.constraintWidth?.constant = width
            }
        }
    }
}
