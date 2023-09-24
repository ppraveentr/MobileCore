//
//  WKWebView+Extension.swift
//  MobileCore-CoreComponents
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import Foundation
import UIKit
import WebKit

public protocol WebViewContentProtocol {
    func pickerColor(textColor: UIColor, backgroundColor: UIColor)
    func fontSize(_ size: Float)
    func fontFamily(_ fontName: String?)
    
    func getTextSize(_ block: ((Float?) -> Void)?)
    func getHTMLColor(_ block: ((_ textColor: UIColor?, _ backgroungColor: UIColor?) -> Void)?)
    func getContentFontFamily(_ block: (([String]) -> Void)?)
}

extension WKWebView {
    public enum Constants {
        fileprivate static let bodyPlaceHolder = "${body}"
        fileprivate static let baseStyle = "<style> body { margin: 20px } </style>"
        fileprivate static let loadHTMLBody = """
            <html>
            <meta name=\"viewport\" content=\"initial-scale=1.0\" />
            <header>\(baseStyle)</header>
            <body>\(bodyPlaceHolder)</body>
            </html>
        """
        public static let getDocumentBody = "document.getElementsByTagName('body')[0]"
        public static let styleAppleFamily = "-apple-system\";"
        
        public static let styleFontFamily = ".style.fontFamily"
        public static let textSizeAdjust = ".style.webkitTextSizeAdjust"
        public static let backgroundColor = ".style.backgroundColor"
        public static let textColor = ".style.color"
    }
    
    private func removeGestureInWKContentView(_ view: [UIView]) {
        for subScrollView in view where type(of: subScrollView) == NSClassFromString("WKContentView") {
            for gesture in subScrollView.gestureRecognizers ?? [] {
                subScrollView.removeGestureRecognizer(gesture)
            }
        }
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
            removeGestureInWKContentView(subview.subviews)
        }
    }
    
    @discardableResult
    public func loadHTMLBody(_ string: String, baseURL: URL? = nil) -> WKNavigation? {
        let body = Constants.loadHTMLBody.replacingOccurrences(of: Constants.bodyPlaceHolder, with: string)
        return self.loadHTMLString(body, baseURL: baseURL)
    }
    
    public func setContentFontSize(_ size: Float) {
        if size >= 10 {
            let js = Constants.getDocumentBody + Constants.textSizeAdjust + "= '\(size)%'"
            self.insertCSSString(jsString: js)
        }
    }
    
    public func setContentColor(textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        
        if let bgHex = backgroundColor?.hexString() {
            let bgJS = Constants.getDocumentBody + Constants.backgroundColor + "= '\(bgHex)';"
            self.insertCSSString(jsString: bgJS)
        }
        
        if let fontHex = textColor?.hexString() {
            let fontJS = Constants.getDocumentBody + Constants.textColor + "= '\(fontHex)';"
            self.insertCSSString(jsString: fontJS)
        }
    }
    
    public func setContentFontFamily(_ fontName: String?) {
        // base document style
        var css = Constants.getDocumentBody + Constants.styleFontFamily + "= \""
        // user selected font
        if let fontName = fontName, !fontName.isEmpty {
            css += "\(fontName),"
        }
        // Default font
        css += Constants.styleAppleFamily
        self.insertCSSString(jsString: css)
    }
}

private extension AssociatedKey {
    static var fontPickerVC = "fontPickerVC"
}

extension WKWebView: WebViewContentProtocol {
    public func pickerColor(textColor: UIColor, backgroundColor: UIColor) {
        setContentColor(textColor: textColor, backgroundColor: backgroundColor)
    }
    
    public func fontSize(_ size: Float) {
        setContentFontSize(size)
    }
    
    public func fontFamily(_ fontName: String?) {
        setContentFontFamily(fontName)
    }
}

public extension WKWebView {
    func getTextSize(_ block: ((Float?) -> Void)?) {
        guard block != nil else { return }
        evaluateJavaScript(Constants.getDocumentBody + Constants.textSizeAdjust) { obj, _ in
            if let size = (obj as? String)?.trimming("%") {
                block?(Float(size))
            }
        }
    }
    
    func getHTMLColor(_ block: ((_ textColor: UIColor?, _ backgroungColor: UIColor?) -> Void)?) {
        guard block != nil else { return }
        var bgColor: UIColor?
        var textColor: UIColor?
        var regBG: String? = Constants.getDocumentBody + Constants.backgroundColor
        var regText: String? = Constants.getDocumentBody + Constants.textColor

        let eval = {
            if regBG == nil, regText == nil {
                block?(textColor, bgColor)
            }
        }
        
        // bg color
        evaluateJavaScript(regBG ?? "") { obj, _ in
            regBG = nil
            bgColor = self.getColor(obj as? String)
            eval()
        }
        
        // text color
        evaluateJavaScript(regText ?? "") { obj, _ in
            regText = nil
            textColor = self.getColor(obj as? String)
            eval()
        }
    }
    
    func getContentFontFamily(_ block: (([String]) -> Void)?) {
        guard block != nil else { return }
        evaluateJavaScript(Constants.getDocumentBody + Constants.styleFontFamily) { obj, _ in
            var fonts: [String] = (obj as? String)?.components(separatedBy: ",") ?? []
            fonts = fonts.map { $0.trimingPrefix(" ") }
            block?(fonts)
        }
    }
    
    // Converts string 'rgb(i, i, i)' into 'UIColor'
    private func getColor(_ color: String?) -> UIColor? {
        if var color = color {
            let colL = color.trimming(["rgb(", ")", " "]).components(separatedBy: ",").map { UInt64($0) ?? 0 }
            return UIColor(red: colL[0], green: colL[1], blue: colL[2])
        }
        return nil
    }
    
    func insertCSSString(jsString: String) {
        self.evaluateJavaScript(jsString, completionHandler: nil)
    }
}
