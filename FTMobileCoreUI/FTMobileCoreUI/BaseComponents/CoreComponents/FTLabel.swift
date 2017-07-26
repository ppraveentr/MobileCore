//
//  FTLabel.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 08/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTLabel : UILabel, NSLayoutManagerDelegate {
    
    public lazy var textStorage: NSTextStorage = self.getTextStorage()
    
    public lazy var textContainer: NSTextContainer = self.getTextContainer()
    
    public lazy var layoutManager: NSLayoutManager = self.getLayoutManager()

    fileprivate var linkRanges: [FTLinkDetection]?
    
    private var linkDetectionEnabled = false
    public var isLinkDetectionEnabled: Bool {
        set {
            self.linkDetectionEnabled = newValue
            self.updateLabelStyleProperty()
        }
        get {
            return linkDetectionEnabled
        }
    }

    private var isLinkUnderLineEnabled = false
    public var linkUndelineEnabled: Bool {
        set {
            isLinkUnderLineEnabled = newValue
            self.updateLabelStyleProperty()
        }
        get {
            return isLinkUnderLineEnabled
        }
    }
    
    open override var text: String? {
        didSet {
            self.updateTextWithAttributedString(attributedString: self.getAttributedText(text: text))
        }
    }
    
    open override var attributedText: NSAttributedString? {
        didSet {
            self.updateTextWithAttributedString(attributedString: attributedText)
        }
    }
    
    open override var frame: CGRect {
        didSet {
            self.updateTextContainerSize()
        }
    }
    
    open override var bounds: CGRect {
        didSet{
            self.updateTextContainerSize()
        }
    }
    
    open override var preferredMaxLayoutWidth: CGFloat {
        didSet {
            self.updateTextContainerSize()
        }
    }
    
    open override var numberOfLines: Int {
        didSet {
            self.textContainer.maximumNumberOfLines = numberOfLines
            self.updateTextContainerSize()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textContainer.size = self.bounds.size
    }
    
    func updateLabelStyleProperty() {
        self.updateTextContainerSize()
        
        self.updateLinkInText()
        
        self.setNeedsDisplay()
    }
}

//MARK: Text Farmatting
extension FTLabel {
    
    func updateTextContainerSize() {
        var localSize = frame.size
        localSize.width = min(localSize.width, self.preferredMaxLayoutWidth)
        localSize.height = 0
        self.textContainer.size = localSize
    }
    
    func updateTextWithAttributedString(attributedString: NSAttributedString?) {
        
        var attributedString = attributedString
        if attributedString == nil {
            attributedString = self.getAttributedText(text: "")
        }
        
        let sanitizedString = self.sanitizeAttributedString(attributedString: attributedString!)
        
        self.textStorage.setAttributedString(sanitizedString)
        
        self.updateLabelStyleProperty()
    }
    
    func getAttributedText(text: String?) -> NSMutableAttributedString {
        
        guard text != nil else {
            return NSMutableAttributedString()
        }
        
        var localAttributedText = NSMutableAttributedString(string: text!)
        localAttributedText.addAttributes(self.getStyleProperties(), range: NSMakeRange(0, localAttributedText.length))
        
        localAttributedText = self.sanitizeAttributedString(attributedString: localAttributedText)
        
        return localAttributedText
    }
    
    func sanitizeAttributedString(attributedString: NSAttributedString) -> NSMutableAttributedString {
        
        var range = NSMakeRange(0, attributedString.length)
        
        guard let praStryle: NSParagraphStyle = attributedString.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: &range) as? NSParagraphStyle else {
            return attributedString.mutableCopy() as! NSMutableAttributedString
        }
        
        let mutablePraStryle: NSMutableParagraphStyle = praStryle.mutableCopy() as! NSMutableParagraphStyle
        mutablePraStryle.lineBreakMode = .byWordWrapping
        
        let restyledString: NSMutableAttributedString = attributedString.mutableCopy() as! NSMutableAttributedString
        restyledString.addAttribute(NSParagraphStyleAttributeName, value: mutablePraStryle, range: NSMakeRange(0, restyledString.length))
        
        return restyledString
    }
    
    func updateLinkInText() {
        
        self.linkRanges = [FTLinkDetection]()

        //HTTP links
        let links = FTLinkDetection.getURLLinkRanges((attributedText?.string) ?? "")
        self.linkRanges?.insert(contentsOf: links, at: 0)
        
    }
}

//TODO: Theams
extension FTLabel {
    
    func getStyleProperties() -> [String : Any] {
        
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.alignment = self.textAlignment
        
        let font = self.font!
        
        let color = self.textColor!
        
        let bgColor = self.backgroundColor ?? UIColor.clear
        
        let properties = [NSParagraphStyleAttributeName : paragrahStyle,
                          NSFontAttributeName: font,
                          NSForegroundColorAttributeName: color,
                          NSBackgroundColorAttributeName: bgColor
            ] as [String : Any]
        
        return properties
    }
}

//MARK: Text Rendering
extension FTLabel {
    
    open override func drawText(in rect: CGRect) {
        
        let range : NSRange = self.layoutManager.glyphRange(for: self.textContainer)
        
        let textOffset = self.textOffsetForGlyph(range: range)
        
        self.layoutManager.drawBackground(forGlyphRange: range, at: textOffset)
        
        self.layoutManager.drawGlyphs(forGlyphRange: range, at: textOffset)
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        let savedContainerSize = self.textContainer.size
        let savedContainerNoLines = self.textContainer.maximumNumberOfLines
        
        self.textContainer.size = bounds.size
        self.textContainer.maximumNumberOfLines = numberOfLines
        
        var textBounds: CGRect = .zero
        
        let glyphRange = self.layoutManager.glyphRange(for: self.textContainer)
        textBounds = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer)
        
        textBounds.origin = bounds.origin
        textBounds.size.width = CGFloat(ceilf(Float(textBounds.size.width)))
        textBounds.size.height = CGFloat(ceilf(Float(textBounds.size.height)))
        
        self.textContainer.size = savedContainerSize
        self.textContainer.maximumNumberOfLines = savedContainerNoLines
        
        self.setViewHeight(textBounds.size.height)
        self.setViewWidth(textBounds.size.width)
        
        return textBounds
    }
    
    func textOffsetForGlyph(range: NSRange) -> CGPoint {
        
        var textOffset: CGPoint = .zero
        
        let textBounds = self.layoutManager.boundingRect(forGlyphRange: range, in: self.textContainer)
        let paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0
        
        if paddingHeight > 0 {
            textOffset.y = paddingHeight
        }
        
        return textOffset
    }
}

//MARK: Container SetUp
extension FTLabel {
    
    func getTextStorage() -> NSTextStorage {
        
        let local = NSTextStorage()
        
        local.addLayoutManager(self.layoutManager)
        
        return local
    }
    
    func getTextContainer() -> NSTextContainer {
        
        let local = NSTextContainer()
        
        local.lineFragmentPadding = 0
        local.maximumNumberOfLines = self.numberOfLines
        local.lineBreakMode = self.lineBreakMode
        local.widthTracksTextView = true
        local.size = self.frame.size
        
        return local
    }
    
    func getLayoutManager() -> NSLayoutManager {
        
        let local = NSLayoutManager()
        
        local.delegate = self
        local.addTextContainer(self.textContainer)
        self.textContainer.replaceLayoutManager(local)
        
        return local
    }
    
}
