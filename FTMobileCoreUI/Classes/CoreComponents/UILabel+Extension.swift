//
//  UILabel+Extension.swift
//  MobileCore
//
//  Created by Praveen P on 20/10/19.
//

import Foundation

public typealias FTLableCompletionBlock = (() -> Void)
public typealias FTLableLinkHandler = (FTLinkDetection) -> Void

protocol FTUILabelProtocol where Self: UILabel {
    var dispatchQueue: DispatchQueue { get }
    var completionBlock: FTLableCompletionBlock? { get set }
    // FTUILabelThemeProperyProtocol
    var islinkDetectionEnabled: Bool { get set }
    var isLinkUnderLineEnabled: Bool { get set }
    // Link handler
    var linkRanges: [FTLinkDetection]? { get set }
    var linkHandler: FTLableLinkHandler? { get set }
    var tapGestureRecognizer: UITapGestureRecognizer { get set }
    // layout
    var layoutManager: NSLayoutManager { get }
    var styleProperties: [NSAttributedString.Key: Any] { get }
}

private extension FTAssociatedKey {
    static var dispatchQueue = "dispatchQueue"
    
    static var textContainer = "textContainer"
    static var layoutManager = "layoutManager"
    
    static var linkRanges = "linkRanges"
    static var completionBlock = "completionBlock"
    static var islinkDetectionEnabled = "islinkDetectionEnabled"
    static var isLinkUnderLineEnabled = "isLinkUnderLineEnabled"
    static var linkHandler = "linkHandler"
    static var tapGestureRecognizer = "tapGestureRecognizer"
}

open class FTLabel: UILabel {
    
//    override open var text: String? {
//        set {
//            if islinkDetectionEnabled, let newValue = newValue, newValue.isHTMLString() {
//                super.text = newValue.stripHTML()
//                self.numberOfLines = 0
//                updateWithHtmlString(text: newValue)
//            }
//            else {
//                super.text = newValue
//                self.updateLabelStyleProperty()
//            }
//        }
//        get {
//            return super.text
//        }
//    }
//
//    override open var isEnabled: Bool {
//        didSet {
//            // update with latest Theme
//            updateVisualProperty()
//        }
//    }
}

extension UILabel: FTUILabelProtocol {
    public var dispatchQueue: DispatchQueue {
        return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.dispatchQueue) { DispatchQueue(label: "FTLabel.dispatchQueue") }!
    }
    
    public var linkRanges: [FTLinkDetection]? {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.linkRanges)
        }
        set {
            FTAssociatedObject<[FTLinkDetection]>.setAssociated(self, value: newValue, key: &FTAssociatedKey.linkRanges)
        }
    }
    
    public var completionBlock: FTLableCompletionBlock? {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.completionBlock)
        }
        set {
            FTAssociatedObject<FTLableCompletionBlock>.setAssociated(self, value: newValue, key: &FTAssociatedKey.completionBlock)
        }
    }
    
    // FTUILabelThemeProperyProtocol
    public var islinkDetectionEnabled: Bool {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.islinkDetectionEnabled) { true }!
        }
        set {
            FTAssociatedObject<Bool>.setAssociated(self, value: newValue, key: &FTAssociatedKey.islinkDetectionEnabled)
            self.updateLabelStyleProperty()
        }
    }
    
    public var isLinkUnderLineEnabled: Bool {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.isLinkUnderLineEnabled) { false }!
        }
        set {
            FTAssociatedObject<Bool>.setAssociated(self, value: newValue, key: &FTAssociatedKey.isLinkUnderLineEnabled)
            self.updateLabelStyleProperty()
        }
    }
    
    public var linkHandler: FTLableLinkHandler? {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.linkHandler)
        }
        set {
            FTAssociatedObject<FTLableLinkHandler>.setAssociated(self, value: newValue, key: &FTAssociatedKey.linkHandler)
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    public var tapGestureRecognizer: UITapGestureRecognizer {
        get {
            return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.tapGestureRecognizer) { UILabel.tapGesture(targer: self) }!
        }
        set {
            FTAssociatedObject<UITapGestureRecognizer>.setAssociated(self, value: newValue, key: &FTAssociatedKey.tapGestureRecognizer)
        }
    }
    
    public var layoutManager: NSLayoutManager {
        return FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.layoutManager) { NSLayoutManager() }!
    }
    
    public var styleProperties: [NSAttributedString.Key: Any] {
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.alignment = self.textAlignment
        paragrahStyle.lineBreakMode = self.lineBreakMode
        
        let bgColor = self.backgroundColor ?? UIColor.clear
        var properties: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragrahStyle,
            .backgroundColor: bgColor
        ]
        
        if let font = self.font {
            properties[.font] = font
        }
        
        if let color = self.textColor {
            properties[.foregroundColor] = color
        }
        
        return properties
    }
}

extension UILabel: FTOptionalLayoutSubview, FTUILabelThemeProperyProtocol {
    
    public func updateViewLayouts() {
        if islinkDetectionEnabled, let newValue = self.text, newValue.isHTMLString() {
            self.text = newValue.stripHTML()
            self.numberOfLines = 0
            updateWithHtmlString(text: newValue)
        }
    }
    
    static func tapGesture(targer: AnyObject?) -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: targer, action: #selector(UILabel.tapGestureRecognized(_:)))
    }
    
    @objc
    func tapGestureRecognized(_ gesture: UITapGestureRecognizer) {
        if self == gesture.view, let link = self.didTapAttributedText(gesture)?.first {
            self.linkHandler?(link)
        }
    }
}

extension UILabel {
    
    // MARK: Text Formatting
    func updateWithHtmlString(text: String?) {
        dispatchQueue.async(qos: DispatchQoS.userInteractive, flags: .enforceQoS) {
            let att = text?.htmlAttributedString()
            DispatchQueue.main.async { [weak self] in
                self?.updateTextWithAttributedString(attributedString: att, text: text)
            }
        }
    }
    
    func updateLabelStyleProperty(isSimpleTextUpdate: Bool = false) {
        // Now update our storage from either the attributedString or the plain text
        if ((self.attributedText?.length ?? 0) != 0) && !isSimpleTextUpdate {
            self.updateTextWithAttributedString(attributedString: self.attributedText)
        }
        else if (text?.count ?? 0) != 0 {
            updateWithHtmlString(text: self.text)
        }
        else {
            self.updateTextWithAttributedString(attributedString: nil)
        }
        layoutView()
    }
    
    func updateTextContainerSize() {
        var localSize = self.intrinsicContentSize
        localSize.width = min(localSize.width, self.preferredMaxLayoutWidth)
        self.frame = CGRect(origin: frame.origin, size: localSize)
    }
    
    func updateTextWithAttributedString(attributedString: NSAttributedString?, text: String? = nil) {
        
        if let attributedString = attributedString {
            let sanitizedString = self.sanitizeAttributedString(attributedString: attributedString)
            sanitizedString.addAttributes(self.styleProperties, range: sanitizedString.nsRange())
            if islinkDetectionEnabled {
                updateLinkInText(attributedString: sanitizedString, text: text)
            }
            self.attributedText = sanitizedString
        }
        
        layoutView()
        
        completionBlock?()
    }
    
    func updateLinkInText(attributedString: NSMutableAttributedString, text: String? = nil) {
        
        self.linkRanges = [FTLinkDetection]()
        
        // HTTP links
        let links = FTLinkDetection.getURLLinkRanges(attributedString)
        self.linkRanges?.insert(contentsOf: links, at: 0)
        
        self.linkRanges?.forEach { link in
            let att = getStyleProperties(forLink: link)
            attributedString.addAttributes(att, range: link.linkRange)
        }
    }
    
    // MARK: Container SetUp
    func layoutView() {
        updateTextContainerSize()
        setNeedsDisplay()
        layoutIfNeeded()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
    }
    
    public func didTapAttributedText(_ gesture: UIGestureRecognizer) -> [FTLinkDetection]? {
        let location = gesture.location(in: self)
        let indexOfCharacter = layoutManager.textBoundingBox(self, touchLocation: location)
        let found = self.linkRanges?.filter { $0.linkRange.contains(indexOfCharacter) }
        return found
    }
    
    // MARK: Text Sanitizing
    
    func getMutableAttributedString(_ string: NSAttributedString) -> NSMutableAttributedString {
        if let value = string.mutableCopy() as? NSMutableAttributedString {
            return value
        }
        return NSMutableAttributedString()
    }
    
    func sanitizeAttributedString(attributedString: NSAttributedString) -> NSMutableAttributedString {
        
        if attributedString.length == 0 {
            return  getMutableAttributedString(attributedString)
        }
        
        var range = attributedString.nsRange()
        guard let praStryle: NSParagraphStyle = attributedString.attribute( .paragraphStyle, at: 0, effectiveRange: &range) as? NSParagraphStyle else {
            return getMutableAttributedString(attributedString)
        }
        
        guard let mutablePraStryle = praStryle.mutableCopy() as? NSMutableParagraphStyle else {
            return getMutableAttributedString(attributedString)
        }
        mutablePraStryle.lineBreakMode = .byWordWrapping
        
        let restyledString = getMutableAttributedString(attributedString)
        restyledString.addParagraphStyle(style: mutablePraStryle)
        return restyledString
    }
    
    // TODO: Themes
    func getStyleProperties(forLink link: FTLinkDetection) -> [NSAttributedString.Key: Any] {
        var properties: [NSAttributedString.Key: Any] = [
            .underlineColor: UIColor.blue,
            .foregroundColor: UIColor.blue
        ]
        if link.linkType == .hashTag {
            properties[.underlineStyle] = NSUnderlineStyle.single
        }
        return properties
    }
    
    var offsetXDivisor: CGFloat {
        switch self.textAlignment {
        case .center:
            return 0.5
        case .right:
            return 1.0
        default:
            return 0.0
        }
    }
}

extension NSLayoutManager {
    
    private func getTextContainer(_ label: UILabel) -> NSTextContainer {
        let local: NSTextContainer = FTAssociatedObject.getAssociated(label, key: &FTAssociatedKey.textContainer) { NSTextContainer() }!
        defer {
            local.replaceLayoutManager(self)
            self.addTextContainer(local)
        }
        local.lineFragmentPadding = 0.0
        local.maximumNumberOfLines = label.numberOfLines
        local.lineBreakMode = label.lineBreakMode
        local.widthTracksTextView = true
        local.heightTracksTextView = true
        local.size = label.bounds.size
        return local
    }
    
    func textBoundingBox(_ label: UILabel, touchLocation: CGPoint) -> Int {
        
        let textContainer = getTextContainer(label)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString(string: ""))
        textStorage.addLayoutManager(self)
        
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let textBoundingBox = self.usedRect(for: textContainer)
        let offsetX = (labelSize.width - textBoundingBox.size.width) * label.offsetXDivisor - textBoundingBox.origin.x
        let offsetY = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint(x: offsetX, y: offsetY)
        let locationOfTouch = CGPoint(
            x: touchLocation.x - textContainerOffset.x,
            y: touchLocation.y - textContainerOffset.y
        )
        
        let indexOfCharacter = self.characterIndex(for: locationOfTouch, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return indexOfCharacter
    }
}
