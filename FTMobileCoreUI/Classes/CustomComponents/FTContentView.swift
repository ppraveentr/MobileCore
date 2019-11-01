//
//  FTContentView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import WebKit

open class FTContentView: UIScrollView, WKNavigationDelegate {
    
    public lazy var webView: WKWebView = self.getWebView()
    private var scrollViewSizeContext = #keyPath(UIScrollView.contentSize)

    private func getWebView() -> WKWebView {
        let local = WKWebView()
        local.navigationDelegate = self
        local.setScrollEnabled(enabled: false)
        self.addContentView(local)
        return local
    }
 
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webView.evaluateJavaScript("document.readyState") { complete, _ in
                if complete != nil {
                    self.webView.evaluateJavaScript("document.body.scrollHeight") { height, _ in
                        let heightValue = (height as? CGFloat) ?? 0
                        self.webView.viewLayoutConstraint.constraintHeight?.constant = heightValue
                        self.webView.viewLayoutConstraint.constraintWidth?.constant = 100

                        //                    self.contentView.viewLayoutConstraint.constraintHeight?.constant = webView.scrollView.contentSize.height
                    }
                }
            }
        }
    }
}
