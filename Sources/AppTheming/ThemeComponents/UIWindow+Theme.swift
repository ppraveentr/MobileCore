//
//  UIWindow+Theme.swift
//  MobileCore
//
//  Created by Praveen Prabhakar on 23/07/21.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import Foundation
import UIKit

public extension NSNotification.Name {
    static let kAppearanceWillRefreshWindow = NSNotification.Name(rawValue: "kAppearance.willRefreshWindow.Notofication")
    static let kAppearanceDidRefreshWindow = NSNotification.Name(rawValue: "kAppearance.didRefreshWindow.Notofication")
}

// MARK: Window Refresh
public extension UIWindow {
    @nonobjc private func refreshAppearance() {
        let constraints = self.constraints
        removeConstraints(constraints)
        for subview in subviews {
            subview.removeFromSuperview()
            addSubview(subview)
        }
        addConstraints(constraints)
    }
    
    /// Refreshes appearance for the window
    /// - Parameter animated: if the refresh should be animated
    func refreshAppearance(animated: Bool) {
        NotificationCenter.default.post(name: .kAppearanceWillRefreshWindow, object: self)
        UIView.animate(
            withDuration: animated ? 0.25 : 0,
            animations: { self.refreshAppearance() },
            completion: { _ in
                NotificationCenter.default.post(name: .kAppearanceDidRefreshWindow, object: self)
            }
        )
    }
}
