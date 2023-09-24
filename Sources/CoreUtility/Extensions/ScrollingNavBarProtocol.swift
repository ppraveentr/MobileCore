//
//  ScrollAnimation.swift
//  MobileCore
//
//  Created by Praveen Prabhakar on 20/07/21.
//

import Foundation
import UIKit

public protocol ScrollingNavBarProtocol where Self: UIViewController {
    func hideNavigationOnScroll(for scrollableView: UIView, delay: Double)
    func navBarAnimation(velocity: CGPoint, animateDuration: TimeInterval, delay: TimeInterval)
    func setBarStatus(hidden: Bool)
    func shouldHideNavigationOnScroll() -> Bool
}

private extension AssociatedKey {
    static var navBarScrollableView = "navBar.scrollableView"
}

extension UIViewController: ScrollingNavBarProtocol {
    // Will hide Navigation bar on scroll
    @objc
    open func shouldHideNavigationOnScroll() -> Bool { true }
    
    private var scrollableView: UIView? {
        get { AssociatedObject<ScrollingNavBar>.getAssociated(self, key: &AssociatedKey.navBarScrollableView)?.scrollableView }
        set {
            var scrollDelegate: ScrollingNavBar?
            if let view = newValue {
                scrollDelegate = ScrollingNavBar(scrollableView: view, delegate: self)
            }
            AssociatedObject<ScrollingNavBar>.setAssociated(self, value: scrollDelegate, key: &AssociatedKey.navBarScrollableView)
        }
    }
    
    public func hideNavigationOnScroll(for scrollableView: UIView, delay: Double = 0) {
        self.scrollableView = scrollableView
    }
    
    public func navBarAnimation(velocity: CGPoint, animateDuration: TimeInterval = 0.01, delay: TimeInterval = 0) {
        let isHidden = velocity.y <= 0
        guard shouldHideNavigationOnScroll(), navigationController?.isNavigationBarHidden != isHidden else { return }
        UIView.animate(withDuration: animateDuration, delay: delay, options: UIView.AnimationOptions.beginFromCurrentState) {
            self.setBarStatus(hidden: isHidden)
        }
    }
    
    public func setBarStatus(hidden: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: true)
        guard self.navigationController?.toolbarItems?.isEmpty ?? false else { return }
        self.navigationController?.setToolbarHidden(hidden, animated: true)
    }
}

private class ScrollingNavBar: NSObject, UIGestureRecognizerDelegate {
    weak var scrollableView: UIView?
    weak var delegate: ScrollingNavBarProtocol?
    private lazy var gestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        gestureRecognizer.maximumNumberOfTouches = 1
        gestureRecognizer.delegate = self
        gestureRecognizer.cancelsTouchesInView = false
        return gestureRecognizer
    }()
    
    deinit {
        scrollableView?.removeGestureRecognizer(gestureRecognizer)
    }
    
    init(scrollableView: UIView, delegate: ScrollingNavBarProtocol) {
        super.init()
        self.scrollableView = scrollableView
        self.delegate = delegate
        self.setupGessture()
    }
    
    func setupGessture() {
        scrollableView?.addGestureRecognizer(gestureRecognizer)
    }
    
    /**
     UIGestureRecognizerDelegate: Begin scrolling only if the direction is vertical (prevents conflicts with horizontal scroll views)
     */
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Default system behavior returns `true`
        guard gestureRecognizer == self.gestureRecognizer, let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
        // Show/Hide Navigation Bar based on velocity of scrolling
        delegate?.navBarAnimation(velocity: velocity)
        return true // abs(velocity.y) > abs(velocity.x)
    }
    
    /**
     UIGestureRecognizerDelegate: Enables the scrolling of both the content and the navigation bar
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Default system behavior returns `false`
        guard [gestureRecognizer, otherGestureRecognizer].contains(self.gestureRecognizer) else { return false }
        return true
    }
}
