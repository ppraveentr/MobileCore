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
    
    public lazy var webView: WKWebView = self.getWebView()
    private var scrollViewSizeContext = #keyPath(UIScrollView.contentSize)

    private func getWebView() -> WKWebView {
        let local = WKWebView()
        local.scrollView.isScrollEnabled = false
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
        // 'contentSize' observer
        webView.scrollView.addObserver(self, forKeyPath: scrollViewSizeContext, options: [NSKeyValueObservingOptions.new], context: &scrollViewSizeContext)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &scrollViewSizeContext,
            keyPath == #keyPath(UIScrollView.contentSize),
            let nsSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            let val = nsSize.height
            // Do something here using content height.
            self.contentView?.viewLayoutConstraint.constraintHeight?.constant = val
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func stopObservingHeight() {
        webView.scrollView.removeObserver(self, forKeyPath: scrollViewSizeContext)
    }
}
