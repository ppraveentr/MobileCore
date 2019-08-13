//
//  FTLabel.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 08/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTLableCompletionBlock = (() -> Void)

open class FTLabel : UILabel, FTUILabelThemeProperyProtocol {

    let dispatchQueue = DispatchQueue(label: "FTLabel.dispatchQueue")
    public lazy var textStorage: NSTextStorage = self.getTextStorage()
    
    public lazy var textContainer: NSTextContainer = self.getTextContainer()
    
    public lazy var layoutManager: NSLayoutManager = self.getLayoutManager()

    fileprivate var linkRanges: [FTLinkDetection]?

    public var completionBlock: FTLableCompletionBlock? = nil

    // FTUILabelThemeProperyProtocol
    public var islinkDetectionEnabled = true {
        didSet {
            self.updateLabelStyleProperty()
        }
    }
    public var isLinkUnderLineEnabled = true {
        didSet {
            self.updateLabelStyleProperty()
        }
    }
    // End: FTUILabelThemeProperyProtocol
    
    override open var text: String? {
        set {
            if islinkDetectionEnabled, newValue != nil, newValue!.isHTMLString() {
                super.text = newValue!.stripHTML()
                updateWithHtmlString(text: newValue)
            } else {
                super.text = newValue
                self.updateLabelStyleProperty()
            }
        }
        get {
            return super.text
        }
    }
    
    override open var attributedText: NSAttributedString? {
        didSet {
            self.updateLabelStyleProperty()
        }
    }
    
    override open var frame: CGRect {
        didSet {
            self.updateTextContainerSize()
        }
    }
    
    override open var bounds: CGRect {
        willSet {
            if frame.width != bounds.width {
                self.bounds = CGRect(origin: bounds.origin, size: CGSize(width: frame.width, height: bounds.height))
            }
        }
        didSet {
            self.updateTextContainerSize()
        }
    }
    
    override open var preferredMaxLayoutWidth: CGFloat {
        didSet {
            self.updateTextContainerSize()
        }
    }
    
    override open var numberOfLines: Int {
        didSet {
            self.textContainer.maximumNumberOfLines = numberOfLines
            self.updateTextContainerSize()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            // update with latest Theme
            updateVisualProperty()
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.updateTextContainerSize()
    }
    
}

// MARK: Text Formatting
extension FTLabel {

    func updateWithHtmlString(text: String?) {
        dispatchQueue.async(qos: DispatchQoS.userInteractive, flags: .enforceQoS) {
            let att = text?.htmlAttributedString()
            DispatchQueue.main.async {
                self.updateTextWithAttributedString(attributedString: att)
            }
        }
    }

    func updateLabelStyleProperty(isSimpleTextUpdate: Bool = false) {

        // Now update our storage from either the attributedString or the plain text
        if ((self.attributedText?.length ?? 0) != 0) && isSimpleTextUpdate == false {
            self.updateTextWithAttributedString(attributedString: self.attributedText)
        }
        else if (text?.length ?? 0) != 0 {
            updateWithHtmlString(text: self.text)
        }
        else {
            self.updateTextWithAttributedString(attributedString: nil)
        }

        layoutView()
    }

    func updateTextContainerSize() {
        var localSize = bounds.size
        localSize.width = min(localSize.width, self.preferredMaxLayoutWidth)
        self.textContainer.size = localSize
    }
    
    func updateTextWithAttributedString(attributedString: NSAttributedString?) {

        if attributedString == nil {
            self.textStorage.setAttributedString(NSMutableAttributedString(string: ""))
        } else {

            let sanitizedString = self.sanitizeAttributedString(attributedString: attributedString!)
            sanitizedString.addAttributes(self.getStyleProperties(), range: NSMakeRange(0, sanitizedString.length))

            if islinkDetectionEnabled {
                updateLinkInText(attributedString: sanitizedString)
            }
            self.textStorage.setAttributedString(sanitizedString)
        }

        layoutView()


        if completionBlock != nil {
            completionBlock!()
        }
    }

    func updateLinkInText(attributedString: NSMutableAttributedString) {
        
        self.linkRanges = [FTLinkDetection]()

        // HTTP links
        let links = FTLinkDetection.getURLLinkRanges((attributedString.string))
        self.linkRanges?.insert(contentsOf: links, at: 0)

        self.linkRanges?.forEach { (link) in
            let att = getStyleProperties(forLink: link)
            attributedString.addAttributes(att, range: link.linkRange)
        }
    }
    
}

// TODO: Themes
extension FTLabel {
    
    func getStyleProperties() -> [NSAttributedString.Key : Any] {

        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.alignment = self.textAlignment
        paragrahStyle.lineBreakMode = self.lineBreakMode
        
        let font = self.font!
        
        let color = self.textColor!
        
        let bgColor = self.backgroundColor ?? UIColor.clear
        
        let properties:[NSAttributedString.Key : Any] = [.paragraphStyle : paragrahStyle,
                          .font: font,
                          .foregroundColor: color,
                          .backgroundColor: bgColor
                        ]
        
        return properties
    }

    func getStyleProperties(forLink link: FTLinkDetection) -> [NSAttributedString.Key : Any] {

        let underlineColor = UIColor.blue
//        let underlineStyle = NSUnderlineStyle.styleSingle

        let linkTextColor = UIColor.blue

        let properties:[NSAttributedString.Key : Any] = [
            .underlineColor: underlineColor,
            .foregroundColor: linkTextColor
        ]

        return properties
    }
    
}

// MARK: Text Sanitizing
extension FTLabel: NSLayoutManagerDelegate {

//    public func layoutManager(_ layoutManager: NSLayoutManager, shouldBreakLineByWordBeforeCharacterAt charIndex: Int) -> Bool {
//
//        var range = NSRange(location: 0, length: (attributedText?.length) ?? 0)
//        if (layoutManager.textStorage?.attribute(.link, at: charIndex, effectiveRange: &range)) != nil {
//            return !(charIndex > range.location && charIndex <= NSMaxRange(range))
//        }
//
//        return true
//    }

    func sanitizeAttributedString(attributedString: NSAttributedString) -> NSMutableAttributedString {

        if attributedString.length == 0 {
            return attributedString.mutableCopy() as! NSMutableAttributedString
        }

        var range = NSMakeRange(0, attributedString.length)

        guard let praStryle: NSParagraphStyle = attributedString.attribute(
            .paragraphStyle, at: 0, effectiveRange: &range) as? NSParagraphStyle else {
                return attributedString.mutableCopy() as! NSMutableAttributedString
        }

        let mutablePraStryle: NSMutableParagraphStyle = praStryle.mutableCopy() as! NSMutableParagraphStyle
        mutablePraStryle.lineBreakMode = .byWordWrapping

        let restyledString: NSMutableAttributedString = attributedString.mutableCopy() as! NSMutableAttributedString
        restyledString.addAttribute(.paragraphStyle, value: mutablePraStryle, range: NSMakeRange(0, restyledString.length))

        return restyledString
    }
    
}

// MARK: Text Rendering
extension FTLabel {
    
    override open func drawText(in rect: CGRect) {

        // Calculate the offset of the text in the view
        let range : NSRange = self.layoutManager.glyphRange(for: self.textContainer)
        let textOffset = self.textOffsetForGlyph(range: range)

        // Drawing code
        self.layoutManager.drawBackground(forGlyphRange: range, at: textOffset)
        self.layoutManager.drawGlyphs(forGlyphRange: range, at: textOffset)
    }
    
    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        let savedContainerSize = self.textContainer.size
        let savedContainerNoLines = self.textContainer.maximumNumberOfLines
        
        self.textContainer.size = bounds.size
        self.textContainer.maximumNumberOfLines = numberOfLines
        
        var textBounds: CGRect = .zero
        
        let glyphRange = self.layoutManager.glyphRange(for: self.textContainer)
        textBounds = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer)
        
        textBounds.origin = bounds.origin
        textBounds.size.width = CGFloat(ceilf(Float(textBounds.width)))
        textBounds.size.height = CGFloat(ceilf(Float(textBounds.height)))
        
        self.textContainer.size = savedContainerSize
        self.textContainer.maximumNumberOfLines = savedContainerNoLines

        return textBounds
    }
    
    func textOffsetForGlyph(range: NSRange) -> CGPoint {
        
        var textOffset: CGPoint = .zero
        
        let textBounds = self.layoutManager.boundingRect(forGlyphRange: range, in: self.textContainer)
        let paddingHeight = (self.bounds.height - textBounds.height) / 2.0
        
        if paddingHeight > 0 {
            textOffset.y = paddingHeight
        }
        
        return textOffset
    }
    
}

// MARK: Container SetUp
extension FTLabel {

    func layoutView() {

        sizeToFit()
        updateTextContainerSize()
        setNeedsDisplay()
        layoutIfNeeded()

        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
    }

    func getTextStorage() -> NSTextStorage {
        
        let local = NSTextStorage()
        
        local.addLayoutManager(self.layoutManager)
        
        return local
    }
    
    func getTextContainer() -> NSTextContainer {
        
        let local = NSTextContainer()
        
        local.lineFragmentPadding = 0
        local.maximumNumberOfLines = self.numberOfLines
        local.lineBreakMode = .byWordWrapping
        local.widthTracksTextView = true
        local.heightTracksTextView = true
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
