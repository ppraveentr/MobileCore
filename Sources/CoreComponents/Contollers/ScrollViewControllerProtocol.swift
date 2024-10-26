//
//  ScrollViewControllerProtocol.swift
//  MobileCore-CoreComponents
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import Foundation
import UIKit

// MARK: AssociatedKey

private extension AssociatedKey {
    static var ScrollVC = Int8(0) // "k.FT.AO.ScrollViewController"
}

public protocol ScrollViewControllerProtocol: ViewControllerProtocol {
    var scrollView: UIScrollView { get }
}

public extension ScrollViewControllerProtocol {

    var scrollView: UIScrollView {
        get {
            guard let scroll = AssociatedObject<UIScrollView>.getAssociated(self, key: &AssociatedKey.ScrollVC) else {
                return self.setupScrollView()
            }
            return scroll
        }
        set {
            setupScrollView(newValue)
        }
    }
}

private extension ScrollViewControllerProtocol {
    
    @discardableResult
    func setupScrollView(_ local: UIScrollView = UIScrollView() ) -> UIScrollView {

        // Load Base view
        setupCoreView()

        if let scroll: UIScrollView = AssociatedObject<UIScrollView>.getAssociated(self, key: &AssociatedKey.ScrollVC) {
            scroll.removeSubviews()
            AssociatedObject<Any>.resetAssociated(self, key: &AssociatedKey.ScrollVC)
        }

        if local.superview == nil {
            self.mainView?.pin(view: local, edgeOffsets: .zero)
            local.setupContentView(local.contentView)
        }

        AssociatedObject<UIScrollView>.setAssociated(self, value: local, key: &AssociatedKey.ScrollVC)

        return local
    }
}
