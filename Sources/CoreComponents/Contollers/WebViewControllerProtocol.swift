//
//  FTWebViewControllerProtocol.swift
//  MobileCore-CoreComponents
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import UIKit
import WebKit

private extension AssociatedKey {
    static var contentVC = Int8(0) // "k.FT.AO.ContentViewController"
}

public protocol WebViewControllerProtocol: ViewControllerProtocol {
    var contentView: WKWebView { get }
}

public extension WebViewControllerProtocol {
    var contentView: WKWebView {
        get { AssociatedObject<WKWebView>.getAssociated(self, key: &AssociatedKey.contentVC) { self.setupContentView() }! }
        set { setupContentView(newValue) }
    }
}

private extension WebViewControllerProtocol {
    @discardableResult
    func setupContentView(_ local: WKWebView = WKWebView() ) -> WKWebView {
        if shouldHideNavigationOnScroll() {
            (self as? ScrollViewControllerProtocol)?.hideNavigationOnScroll(for: local.scrollView)
        }
        // Load Base view
        setupCoreView()
        if let scroll: WKWebView = AssociatedObject<WKWebView>.getAssociated(self, key: &AssociatedKey.contentVC) {
            scroll.removeFromSuperview()
            AssociatedObject<Any>.resetAssociated(self, key: &AssociatedKey.contentVC)
        }
        if local.superview == nil {
            self.mainView?.pin(view: local, edgeOffsets: .zero)
        }
        AssociatedObject<WKWebView>.setAssociated(self, value: local, key: &AssociatedKey.contentVC)
        return local
    }
}
