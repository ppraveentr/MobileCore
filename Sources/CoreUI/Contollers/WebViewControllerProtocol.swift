//
//  FTWebViewControllerProtocol.swift
//  CoreUIExtensions
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
        if local.scrollView.delegate == nil {
            local.scrollView.delegate = WebViewControllerViewDelegate.shared
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

internal class WebViewControllerViewDelegate: NSObject, UIScrollViewDelegate {
    // MARK: - Shared delegate
    static var shared = WebViewControllerViewDelegate()
    var shouldHideNav = false
    
    var navigationController: UINavigationController? {
        UIWindow.topViewController?.navigationController
    }

    // MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? { nil }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.01, delay: 0, options: UIView.AnimationOptions()) {
            self.setBarStatus(hidden: velocity.y > 0)
        }
    }
    
    func setBarStatus(hidden: Bool) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: true)
        guard self.navigationController?.toolbarItems?.isEmpty ?? false else { return }
        self.navigationController?.setToolbarHidden(hidden, animated: true)
    }
}
