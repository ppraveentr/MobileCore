//
//  FTWebView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import WebKit

open class FTWebView: WKWebView {
    
//    public override func addSelfSizing() {
//        self.addSelfSizing()
//    }
//    
//    public func resizeToFitSubviews() {
//        
//    }
    
    public func setScrollEnabled(enabled: Bool) {
        
        self.scrollView.isScrollEnabled = enabled
        self.scrollView.panGestureRecognizer.isEnabled = enabled
        self.scrollView.bounces = enabled
        
        for subview in self.subviews {
            if let subview = subview as? UIScrollView {
                subview.isScrollEnabled = enabled
                subview.bounces = enabled
                subview.panGestureRecognizer.isEnabled = enabled
            }
            
            for subScrollView in subview.subviews {
                if type(of: subScrollView) == NSClassFromString("WKContentView")! {
                    for gesture in subScrollView.gestureRecognizers! {
                        subScrollView.removeGestureRecognizer(gesture)
                    }
                }
            }
        }
    }
    
}

extension FTWebView {
    
    @discardableResult
    public func loadHTMLBody(_ string: String, baseURL: URL? = nil) -> WKNavigation? {
        return self.loadHTMLString("<html><meta name=\"viewport\" content=\"initial-scale=1.0\" /><body>\(string)</body></html>",
            baseURL: baseURL)
    }
    
    func getHTMLBodyText() -> String {
        return "document.getElementsByTagName('body')[0]"
    }
    
    public func setContentFontSize(_ size: Float) {
        
        if size >= 10 {
            let js = self.getHTMLBodyText() + ".style.webkitTextSizeAdjust= '\(size)%'"
            self.insertCSSString(jsString: js)
        }
    }
    
    public func setContentColor(textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        
        if let bgHex = backgroundColor?.hexString() {
            let bgJS = self.getHTMLBodyText() + ".style.backgroundColor= \"\(bgHex)\";"
            self.insertCSSString(jsString: bgJS)
        }
        
        if let fontHex = textColor?.hexString() {
            let fontJS = self.getHTMLBodyText() + ".style.color= \"\(fontHex)\";"
            self.insertCSSString(jsString: fontJS)
        }
    }
    
    public func setContentFontFamily(_ fontName: String?) {
        
        // base document style
        var css = self.getHTMLBodyText() + ".style.fontFamily= \""
        
        // user selected font
        css += ( (fontName != nil && fontName != "") ? "\(fontName!)," : "")
        
        // Default font
        css += "-apple-system\";"
        
        self.insertCSSString(jsString: css)
    }
    
    func insertCSSString(jsString: String) {
        self.evaluateJavaScript(jsString, completionHandler: nil)
    }
    
}
