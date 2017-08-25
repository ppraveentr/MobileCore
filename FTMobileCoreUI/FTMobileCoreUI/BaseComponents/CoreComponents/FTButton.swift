//
//  FTButton.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 13/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTButton: FTUIButton {}

//open class FTButton: FTUIButton {
//    
////    fileprivate let HEIGHT_TO_FONT_SIZE: Float = 0.47
//    fileprivate let HEIGHT_TO_MARGIN: Float = 0.07
//    fileprivate let HEIGHT_TO_PADDING: Float = 0.23
//    fileprivate let HEIGHT_TO_TEXT_PADDING_CORRECTION: Float = 0.08
//    
//    var _skipIntrinsicContentSizing = false
//    var _isExplicitlyDisabled = false
//    
//    public func isImplicitlyDisabled() -> Bool { return false }
//    
//    //MARK: Object Lifecycle
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        _skipIntrinsicContentSizing = true
//        self.configureButton()
//        _skipIntrinsicContentSizing = false
//    }
//    
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        _skipIntrinsicContentSizing = true
//        self.configureButton()
//        _skipIntrinsicContentSizing = false
//    }
//    
////    deinit {
////        NotificationCenter.default.removeObserver(self)
////    }
//    
//    //MARK: Properties
//    
//    open override var isEnabled: Bool {
//        didSet{
//            _isExplicitlyDisabled = isEnabled
//            self.checkImplicitlyDisabled()
//        }
//    }
//    
//    //MARK: Layout
//    
//    open override var intrinsicContentSize: CGSize{
//        get{
//            
//            if _skipIntrinsicContentSizing { return .zero }
//            
//            _skipIntrinsicContentSizing = true
//            let size = self.sizeThatFits(FTSizeMax())
//            _skipIntrinsicContentSizing = false
//            
//            return size
//        }
//    }
//    
//    open override func sizeThatFits(_ size: CGSize) -> CGSize {
//        
//        if self.isHidden { return .zero }
//        
//        let normalSize = self.sizeThatFits(size: size, title: self.title(for: .normal))
//        let selectedSize = self.sizeThatFits(size: size, title: self.title(for: .selected))
//
//        return FTMaxSize(normalSize, selectedSize)
//    }
//    
//    open override func sizeToFit() {
//        var bounds = self.bounds
//        bounds.size = self.sizeThatFits(FTSizeMax())
//        self.bounds = bounds
//    }
//    
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//    }
//    
//    func configureButton() {
//        let forceSizeToFit = self.bounds.isEmpty;
//
//        if (forceSizeToFit) {
//            self.sizeToFit();
//        }
//        
//        self.contentHorizontalAlignment = .fill
//        self.contentVerticalAlignment = .fill
//    }
//}
//
//extension FTButton {
//    
//    //MARK: Layout
//    
//    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
//        
//        if self.isHidden || self.bounds.isEmpty || self.currentImage == nil { return .zero }
//        
//        var imageRect: CGRect = UIEdgeInsetsInsetRect(contentRect, self.imageEdgeInsets)
//        imageRect.size.width = imageRect.height;
//
////        //Make sure, text size takes precedence over imageSize
////        if (self.titleLabel?.text != nil) {
////            let size = self.sizeThatFits(FTSizeMax())
////            if size.height.isFinite {
////                imageRect.size.width = size.height
////                imageRect.size.height = size.height
////            }
////        }
//        
//        imageRect.size.width += self.imageEdgeInsets.right
//        imageRect.size.height += self.imageEdgeInsets.bottom
//        
//        return imageRect.normalize()
//    }
//    
//    override open func titleRect(forContentRect contentRect: CGRect) -> CGRect {
//        
//        if self.isHidden || self.bounds.isEmpty { return .zero }
//        
//        let imageRect: CGRect = self.imageRect(forContentRect: contentRect)
//        let height = self._heightForContentRect(contentRect)
//        let padding = self.currentImage != nil ? CGFloat(self._paddingForHeight(height)) : 0.0
//        
//        let titleX = CGFloat(imageRect.maxX + padding)
//        
//        let titleRect = CGRect(x: titleX, y: 0.0,
//                               width: contentRect.width - titleX,
//                               height: contentRect.height)
//        
//        var titleEdgeInsets: UIEdgeInsets = .zero
//        
//        if
//            !self.layer.needsLayout(),
//            let titleLabel = self.titleLabel,
//            (titleLabel.textAlignment == .center) {
//            
//            // if the text is centered, we need to adjust the frame for the titleLabel based on the size of the text in order
//            // to keep the text centered in the button without adding extra blank space to the right when unnecessary
//            // 1. the text fits centered within the button without colliding with the image (imagePaddingWidth)
//            // 2. the text would run into the image, so adjust the insets to effectively left align it (textPaddingWidth)
//            
//            let titleSize = FTTextSize(text: titleLabel.text, font: titleLabel.font, constrainedSize: titleRect.size, lineBreakMode: titleLabel.lineBreakMode)
//            
//            let titlePadding = (titleRect.width - titleSize.width) / 2
//            let imagePadding = titleX / 2
//            
//            let inset = min(titlePadding, imagePadding)
//            
//            titleEdgeInsets.left -= inset
//            titleEdgeInsets.right += inset
//        }
//        
//        return UIEdgeInsetsInsetRect(titleRect, titleEdgeInsets)
//    }
//}
//
//extension FTButton {
//    
//    //MARK: Subclass Methods
//    func checkImplicitlyDisabled() {
//        let enabled = !_isExplicitlyDisabled && !self.isImplicitlyDisabled()
//        let currentEnabled = self.isEnabled
//        
//        super.isEnabled = enabled
//        if currentEnabled == enabled {
//            self.invalidateIntrinsicContentSize()
//            self.setNeedsLayout()
//        }
//    }
//}
//
//extension FTButton {
//    
//    func defaultFont() -> UIFont {
//       return UIFont.systemFont(ofSize: 14)
//    }
//    
//    func sizeThatFits(size: CGSize, title: String?) -> CGSize {
//        
//        guard let title = title else { return .zero }
//        
//        let font = self.titleLabel?.font ?? defaultFont()
//        
//        let height = self._heightForFont(font)
//        let padding = self._paddingForHeight(height) - self._textPaddingCorrectionForHeight(height)
//        let contentPadding = CGFloat((self.currentImage != nil) ? height + padding*2 : padding)
//        
//        let constrainedContentSize = FTEdgeInsetsInsetSize(size: size, insets: self.contentEdgeInsets)
//        
//        let titleSize = FTTextSize(text: title, font: font, constrainedSize: constrainedContentSize, lineBreakMode: self.titleLabel?.lineBreakMode ?? .byWordWrapping)
//        
//        let contentSize = CGSize(width: titleSize.width + contentPadding, height: CGFloat(height))
//        
//        return FTEdgeInsetsOutsetSize(size: contentSize, insets: self.contentEdgeInsets)
//    }
//    
//    func _heightForContentRect(_ contentRect: CGRect) -> Float {
//        let contentEdgeInsets = self.contentEdgeInsets;
//        return Float(contentEdgeInsets.top + contentRect.height + contentEdgeInsets.bottom)
//    }
//    
//    func _heightForFont(_ font: UIFont) -> Float {
//        return floorf(Float(font.pointSize) / (1 - 2 * HEIGHT_TO_MARGIN) )
//    }
//    
//    func _marginForHeight(_ height: Float) -> Float {
//        return floorf(height * HEIGHT_TO_MARGIN);
//    }
//    
//    func _paddingForHeight(_ height: Float) -> Float {
//        return roundf(height * HEIGHT_TO_PADDING) - self._textPaddingCorrectionForHeight(height);
//    }
//    
//    func _textPaddingCorrectionForHeight(_ height: Float) -> Float {
//        return floorf(height * HEIGHT_TO_TEXT_PADDING_CORRECTION)
//    }
//    
//}

