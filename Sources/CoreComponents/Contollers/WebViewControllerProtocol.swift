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

private var kContentVC = "k.FT.AO.ContentViewController"

public protocol WebViewControllerProtocol: ViewControllerProtocol {
    var contentView: WKWebView { get }
}

public extension WebViewControllerProtocol {
    var contentView: WKWebView {
        get { AssociatedObject<WKWebView>.getAssociated(self, key: &kContentVC) { self.setupContentView() }! }
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
        if let scroll: WKWebView = AssociatedObject<WKWebView>.getAssociated(self, key: &kContentVC) {
            scroll.removeFromSuperview()
            AssociatedObject<Any>.resetAssociated(self, key: &kContentVC)
        }
        if local.superview == nil {
            self.mainView?.pin(view: local, edgeOffsets: .zero)
        }
        AssociatedObject<WKWebView>.setAssociated(self, value: local, key: &kContentVC)
        return local
    }
}
