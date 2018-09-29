//
//  FTContentView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTContentView: FTScrollView {
    
    var MyObservationContext = 0

    lazy public var webView: FTWebView = self.getWebView()
    
    var observing = false
    
    private func getWebView() -> FTWebView {
        
        let webView = FTWebView()
        
        super.contentView.pin(view: webView)
        
        self.startObservingHeight(webView)
        
        return webView
    }
    
    deinit {
        stopObservingHeight()
    }
    
    // Observe webview content height
    func startObservingHeight(_ webView: FTWebView) {
        
        webView.scrollView.isScrollEnabled = false
        
        webView.setScrollEnabled(enabled: false)
        
        let options = NSKeyValueObservingOptions([.new])
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true
    }
    
    func stopObservingHeight() {
        webView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath,
            let context = context else {
                super.observeValue(forKeyPath: nil, of: object, change: change, context: nil)
                return
        }
        
        switch (keyPath, context) {
        case("contentSize", &MyObservationContext):
            
            if let nsSize = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                let val = nsSize.cgSizeValue.height
                // Do something here using content height.
                self.contentView.viewLayoutConstraint.constraintHeight?.constant = val
            }
            
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
//   func updateHeight() {
//       
//       self.webView.evaluateJavaScript("document.body.scrollHeight") { (obj, error) in
//           if let hei = obj as? CGFloat {
//               self.contentView.viewLayoutConstraint.constraintHeight?.constant = hei
//           }
//       }
//   }
    
}
