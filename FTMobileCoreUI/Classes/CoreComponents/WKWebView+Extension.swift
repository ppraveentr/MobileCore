//
//  SegmentedControl+Extension.swift
//  CoreUIExtensions
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
        case styleAppleFamily = "-apple-system\";"
        
        case styleFontFamily = ".style.fontFamily"
        case textSizeAdjust = ".style.webkitTextSizeAdjust"
        case backgroundColor = ".style.backgroundColor"
        case textColor = ".style.color"
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
        let body = Constants.loadHTMLBody.rawValue.replacingOccurrences(of: Constants.replaceText.rawValue, with: string)
        return self.loadHTMLString(body, baseURL: baseURL)
    }
    
    public func setContentFontSize(_ size: Float) {
        if size >= 10 {
            let js = self.getHTMLBodyText() + Constants.textSizeAdjust.rawValue + "= '\(size)%'"
            self.insertCSSString(jsString: js)
        }
    }
    
    public func setContentColor(textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        
        if let bgHex = backgroundColor?.hexString() {
            let bgJS = self.getHTMLBodyText() + Constants.backgroundColor.rawValue + "= '\(bgHex)';"
            self.insertCSSString(jsString: bgJS)
        }
        
        if let fontHex = textColor?.hexString() {
            let fontJS = self.getHTMLBodyText() + Constants.textColor.rawValue + "= '\(fontHex)';"
            self.insertCSSString(jsString: fontJS)
        }
    }
    
    public func setContentFontFamily(_ fontName: String?) {
        // base document style
        var css = self.getHTMLBodyText() + Constants.styleFontFamily.rawValue + "= \""
        // user selected font
        if let fontName = fontName, !fontName.isEmpty {
            css += "\(fontName),"
        }
        // Default font
        css += Constants.styleAppleFamily.rawValue
        self.insertCSSString(jsString: css)
    }
}

private extension AssociatedKey {
    static var fontPickerVC = "fontPickerVC"
}

extension WKWebView: FontPickerViewprotocol {
    
    public var fontPickerViewController: FontPickerViewController {
        get {
            AssociatedObject.getAssociated(self, key: &AssociatedKey.fontPickerVC) { self.getFontPickerController() }!
        }
        set {
            AssociatedObject<FontPickerViewController>.setAssociated(self, value: newValue, key: &AssociatedKey.fontPickerVC)
        }
    }
    
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
    
    private func getFontPickerController() -> FontPickerViewController {
        let popoverContent = FontPickerViewController()
        popoverContent.fontPickerViewDelegate = self
        return popoverContent
    }
    
    func getHTMLBodyText() -> String {
        Constants.getDocumentBody.rawValue
    }
    
    func getTextSize(_ block: @escaping (Float?) -> Void) {
        evaluateJavaScript(self.getHTMLBodyText() + Constants.textSizeAdjust.rawValue) { obj, _ in
            if let size = (obj as? String)?.trimming("%") {
                block(Float(size))
            }
        }
    }
    
    func getHTMLColor(_ block: @escaping (_ textColor: UIColor?, _ backgroungColor: UIColor?) -> Void) {
        var bgColor: UIColor?
        var textColor: UIColor?
        var regBG: String? = self.getHTMLBodyText() + Constants.backgroundColor.rawValue
        var regText: String? = self.getHTMLBodyText() + Constants.textColor.rawValue

        let eval = {
            if regBG == nil, regText == nil {
                block(textColor, bgColor)
            }
        }
        
        // bg color
        evaluateJavaScript(regBG!) { obj, _ in
            regBG = nil
            bgColor = self.getColor(obj as? String)
            eval()
        }
        
        // text color
        evaluateJavaScript(regText!) { obj, _ in
            regText = nil
            textColor = self.getColor(obj as? String)
            eval()
        }
    }
    
    func getContentFontFamily(_ block: @escaping ([String]) -> Void) {
        evaluateJavaScript(self.getHTMLBodyText() + Constants.styleFontFamily.rawValue) { obj, _ in
            var fonts: [String] = (obj as? String)?.components(separatedBy: ",") ?? []
            fonts = fonts.map { $0.trimingPrefix(" ") }
            block(fonts)
        }
    }
    
    // Converts string 'rgb(i, i, i)' into 'UIColor'
    private func getColor(_ color: String?) -> UIColor? {
        if var color = color {
            let colL = color.trimming(["rgb(", ")", " "]).components(separatedBy: ",").map { UInt32($0) ?? 0 }
            return UIColor(red: colL[0], green: colL[1], blue: colL[2])
        }
        return nil
    }
    
    func insertCSSString(jsString: String) {
        self.evaluateJavaScript(jsString, completionHandler: nil)
    }
}
