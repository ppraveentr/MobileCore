//
//  FTContentView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import WebKit

open class FTContentView: UIScrollView {
    
    var observationContext: NSKeyValueObservation?
    public lazy var webView: WKWebView = self.getWebView()
    public weak var scrollView: UIScrollView?

    private func getWebView() -> WKWebView {
        let local = WKWebView()
        super.contentView?.pin(view: local)
        self.startObservingHeight(local)
        return local
    }
    
    deinit {
        // Remove all Observer in `self`
        NotificationCenter.default.removeObserver(self)
        stopObservingHeight()
    }
    
    // MARK: Observe webview content height
    func startObservingHeight(_ webView: WKWebView) {
        self.scrollView = webView.scrollView
        self.scrollView?.isScrollEnabled = false
        webView.setScrollEnabled(enabled: false)
        // 'contentSize' observer
        observationContext = self.scrollView?.observe(\.contentSize) { _, change in
            if let nsSize = change.newValue {
                let val = nsSize.height
                // Do something here using content height.
                self.contentView?.viewLayoutConstraint.constraintHeight?.constant = val
            }
        }
    }
    
    func stopObservingHeight() {
        observationContext?.invalidate()
    }
}
