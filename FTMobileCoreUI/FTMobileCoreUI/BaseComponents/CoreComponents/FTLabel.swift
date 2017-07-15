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

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textContainer.size = self.bounds.size
    }
    
}

extension FTLabel {
    
    open override var text: String? {
        didSet {
            self.textStorage.setAttributedString(self.getAttributedText(text: text))
        }
    }
    
    open override var attributedText: NSAttributedString? {
        didSet {
            self.textStorage.setAttributedString(attributedText!)
        }
    }
    
    func getAttributedText(text: String?) -> NSAttributedString {
        
        guard text != nil else {
            return NSAttributedString()
        }
        
        let localAttributedText = NSMutableAttributedString(string: text!)
        
        
        return localAttributedText
    }
}

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
    
    open override var frame: CGRect {
        didSet {
            self.updateTextContainerSize()
        }
    }
    
    open override var preferredMaxLayoutWidth: CGFloat {
        didSet {
            self.updateTextContainerSize()

        }
    }
    
    func updateTextContainerSize() {
        var localSize = frame.size
        localSize.width = min(localSize.width, self.preferredMaxLayoutWidth)
        localSize.height = 0
        self.textContainer.size = localSize
    }
}

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
