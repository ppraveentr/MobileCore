//
//  ScrollView+Extension.swift
//  CoreUIExtensions
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

extension UIScrollView {

    private static let aoCollectionViewController = AssociatedObject<UIView>(policy: .OBJC_ASSOCIATION_ASSIGN)
    
    @IBOutlet
    public weak var contentView: UIView! {
        get {
            if let view = UIScrollView.aoCollectionViewController[self] {
                return view
            }
            return self.addContentView(UIView())
        }
        set {
            UIScrollView.aoCollectionViewController[self] = newValue
        }
    }

    public func setupContentView(_ view: UIView) {
        // Remove old contentView & update with new view
        UIScrollView.aoCollectionViewController[self]?.removeFromSuperview()
        addContentView(view)
    }
    
    // Add selfSizing-View to subView
    @discardableResult
    func addContentView(_ view: UIView) -> UIView {
        self.contentView = view
        self.pin(view: view, edgeInsets: [.all], priority: .required)
        self.pin(view: view, edgeInsets: [.centerMargin], priority: .defaultLow)
        view.addSelfSizing()
        return view
    }
}
