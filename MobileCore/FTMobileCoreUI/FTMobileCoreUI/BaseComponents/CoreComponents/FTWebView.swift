//
//  FTWebView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    
    private enum Constants: String {
        case replaceText = "XXXX"
        case loadHTMLBody = "<html><meta name=\"viewport\" content=\"initial-scale=1.0\" /><body>XXXX</body></html>"
        case getDocumentBody = "document.getElementsByTagName('body')[0]"
        case styleFontFamily = ".style.fontFamily= \""
        case styleAppleFamily = "-apple-system\";"
    }
    
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
            
            for subScrollView in subview.subviews where type(of: subScrollView) == NSClassFromString("WKContentView") {
                if let gestures = subScrollView.gestureRecognizers {
                    for gesture in gestures {
                        subScrollView.removeGestureRecognizer(gesture)
                    }
                }
            }
        }
    }
    
    @discardableResult
    public func loadHTMLBody(_ string: String, baseURL: URL? = nil) -> WKNavigation? {
        let body = Constants.loadHTMLBody.rawValue.replacingOccurrences(of: Constants.replaceText.rawValue, with: string)
        return self.loadHTMLString(body, baseURL: baseURL)
    }
    
    func getHTMLBodyText() -> String {
        return Constants.getDocumentBody.rawValue
    }
    
    public func setContentFontSize(_ size: Float) {
        
        if size >= 10 {
            let js = self.getHTMLBodyText() + ".style.webkitTextSizeAdjust= '\(size)%'"
            self.insertCSSString(jsString: js)
        }
    }
    
    public func setContentColor(textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        
        if let bgHex = backgroundColor?.hexString() {
            let bgJS = self.getHTMLBodyText() + ".style.backgroundColor= '\(bgHex)';"
            self.insertCSSString(jsString: bgJS)
        }
        
        if let fontHex = textColor?.hexString() {
            let fontJS = self.getHTMLBodyText() + ".style.color= '\(fontHex)';"
            self.insertCSSString(jsString: fontJS)
        }
    }
    
    public func setContentFontFamily(_ fontName: String?) {
        
        // base document style
        var css = self.getHTMLBodyText() + Constants.styleFontFamily.rawValue
        // user selected font
        css += ( (fontName != nil && fontName != "") ? "\(fontName!)," : "")
        // Default font
        css += Constants.styleAppleFamily.rawValue
        self.insertCSSString(jsString: css)
    }
    
    func insertCSSString(jsString: String) {
        self.evaluateJavaScript(jsString, completionHandler: nil)
    }
}
