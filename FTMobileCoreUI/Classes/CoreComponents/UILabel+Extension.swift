//
//  UILabel+Extension.swift
//  MobileCore
//
//  Created by Praveen P on 20/10/19.
//

import Foundation

public typealias FTLabelLinkHandler = (FTLinkDetection) -> Void

protocol FTUILabelProtocol where Self: UILabel {
    var dispatchQueue: DispatchQueue { get }
    // Link handler
    var linkRanges: [FTLinkDetection]? { get set }
    var linkHandler: FTLabelLinkHandler? { get set }
    var tapGestureRecognizer: UITapGestureRecognizer { get }
    // layout
    var layoutManager: NSLayoutManager { get }
    var styleProperties: FTAttributedStringKey { get set }
}

private extension FTAssociatedKey {
    static var dispatchQueue = "dispatchQueue"
    
    static var textContainer = "textContainer"
    static var layoutManager = "layoutManager"
    static var styleProperties = "styleProperties"

    static var linkRanges = "linkRanges"
    static var islinkDetectionEnabled = "islinkDetectionEnabled"
    static var isLinkUnderLineEnabled = "isLinkUnderLineEnabled"
    static var linkHandler = "linkHandler"
    static var tapGestureRecognizer = "tapGestureRecognizer"
}

extension UILabel: FTUILabelProtocol, FTUILabelThemeProperyProtocol {
    
    public var dispatchQueue: DispatchQueue {
        FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.dispatchQueue) { DispatchQueue(label: "UILabel.dispatchQueue") }!
    }
    
    public var linkRanges: [FTLinkDetection]? {
        get {
            FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.linkRanges)
        }
        set {
            FTAssociatedObject<[FTLinkDetection]>.setAssociated(self, value: newValue, key: &FTAssociatedKey.linkRanges)
        }
    }
    
    // FTUILabelThemeProperyProtocol
    public var islinkDetectionEnabled: Bool {
        get {
            FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.islinkDetectionEnabled) { true }!
        }
        set {
            FTAssociatedObject<Bool>.setAssociated(self, value: newValue, key: &FTAssociatedKey.islinkDetectionEnabled)
        }
    }
    
    public var isLinkUnderLineEnabled: Bool {
        get {
            FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.isLinkUnderLineEnabled) { false }!
        }
        set {
            FTAssociatedObject<Bool>.setAssociated(self, value: newValue, key: &FTAssociatedKey.isLinkUnderLineEnabled)
        }
    }
    
    public var linkHandler: FTLabelLinkHandler? {
        get {
            FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.linkHandler)
        }
        set {
            FTAssociatedObject<FTLabelLinkHandler>.setAssociated(self, value: newValue, key: &FTAssociatedKey.linkHandler)
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    public var tapGestureRecognizer: UITapGestureRecognizer {
        FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.tapGestureRecognizer) { UILabel.tapGesture(targer: self) }!
    }
    
    public var layoutManager: NSLayoutManager {
        FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.layoutManager) { NSLayoutManager() }!
    }
    
    public var textContainer: NSTextContainer {
        let local: NSTextContainer = FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.textContainer) { self.getTextContainer() }!
        local.lineFragmentPadding = 0.0
        local.maximumNumberOfLines = self.numberOfLines
        local.lineBreakMode = self.lineBreakMode
        local.widthTracksTextView = true
        local.heightTracksTextView = true
        local.size = self.bounds.size
        return local
    }
    
    public var styleProperties: FTAttributedStringKey {
        get {
            FTAssociatedObject.getAssociated(self, key: &FTAssociatedKey.styleProperties) { self.defaultStyleProperties }!
        }
        set {
            FTAssociatedObject<FTAttributedStringKey>.setAssociated(self, value: newValue, key: &FTAssociatedKey.styleProperties)
        }
    }
    
    public var htmlText: String {
        set {
            updateWithHtmlString(text: newValue)
        }
        get {
            return ""
        }
    }
}

extension UILabel: FTOptionalLayoutSubview {
    
    public func updateVisualThemes() {
        if islinkDetectionEnabled, self.text.isHTMLString, let newValue = self.text {
            self.text = newValue.stripHTML()
            self.numberOfLines = 0
            updateWithHtmlString(text: newValue)
        }
    }
    
    public func updateViewLayouts() {
        updateVisualThemes()
    }
    
    private static func tapGesture(targer: AnyObject?) -> UITapGestureRecognizer {
        UITapGestureRecognizer(target: targer, action: #selector(UILabel.tapGestureRecognized(_:)))
    }
    
    @objc
    func tapGestureRecognized(_ gesture: UITapGestureRecognizer) {
        if self == gesture.view, let link = self.didTapAttributedText(gesture)?.first {
            self.linkHandler?(link)
        }
    }
    
    fileprivate var offsetXDivisor: CGFloat {
        switch self.textAlignment {
        case .center: return 0.5
        case .right: return 1.0
        default: return 0.0
        }
    }
    
    private func getTextContainer() -> NSTextContainer {
        let container = NSTextContainer()
        container.replaceLayoutManager(self.layoutManager)
        self.layoutManager.addTextContainer(container)
        return container
    }
    
    private var defaultStyleProperties: FTAttributedStringKey {
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.alignment = self.textAlignment
        paragrahStyle.lineBreakMode = self.lineBreakMode
        
        var properties: FTAttributedStringKey = [
            .paragraphStyle: paragrahStyle,
            .backgroundColor: self.backgroundColor ?? UIColor.clear
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

extension UILabel {
    
    // MARK: Text Formatting
    func updateWithHtmlString(text: String?) {
        dispatchQueue.async(qos: DispatchQoS.userInteractive, flags: .enforceQoS) {
            let att = text?.htmlAttributedString()
            DispatchQueue.main.async { [weak self] in
                self?.updateTextWithAttributedString(attributedString: att)
            }
        }
    }
    
    func updateTextContainerSize() {
        var localSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        localSize.width = min(localSize.width, self.preferredMaxLayoutWidth)
        self.frame = CGRect(origin: frame.origin, size: localSize)
    }
    
    func updateTextWithAttributedString(attributedString: NSAttributedString?) {
        if let attributedString = attributedString {
            let sanitizedString = self.sanitizeAttributedString(attributedString: attributedString)
            sanitizedString.addAttributes(self.styleProperties, range: sanitizedString.nsRange())
            if islinkDetectionEnabled {
                updateLinkInText(attributedString: sanitizedString)
            }
            self.attributedText = sanitizedString
        }
        layoutTextView()
    }
    
    func updateLinkInText(attributedString: NSMutableAttributedString) {
        self.linkRanges = FTLinkDetection.appendLink(attributedString: attributedString)
    }
    
    // MARK: Container SetUp
    func layoutTextView() {
        updateTextContainerSize()
        layoutView()
    }
    
    public func didTapAttributedText(_ gesture: UIGestureRecognizer) -> [FTLinkDetection]? {
        let indexOfCharacter = layoutManager.indexOfCharacter(self, touchLocation: gesture.location(in: self))
        return self.linkRanges?.filter { $0.linkRange.contains(indexOfCharacter) }
    }
    
    // MARK: Text Sanitizing
    func sanitizeAttributedString(attributedString: NSAttributedString) -> NSMutableAttributedString {
        
        if attributedString.length == 0 {
            return attributedString.mutableString()
        }
        
        var range = attributedString.nsRange()
        guard let praStryle: NSParagraphStyle = attributedString.attribute( .paragraphStyle, at: 0, effectiveRange: &range) as? NSParagraphStyle else {
            return attributedString.mutableString()
        }
        
        guard let mutablePraStryle = praStryle.mutableCopy() as? NSMutableParagraphStyle else {
            return attributedString.mutableString()
        }
        mutablePraStryle.lineBreakMode = .byWordWrapping
        
        let restyledString = attributedString.mutableString()
        restyledString.addParagraphStyle(style: mutablePraStryle)
        return restyledString
    }
}

extension NSLayoutManager {
    func indexOfCharacter(_ label: UILabel, touchLocation: CGPoint) -> Int {
        let textContainer = label.textContainer
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString(string: ""))
        textStorage.addLayoutManager(self)        
        let (labelSize, textBoundingBox) = (label.bounds.size, self.usedRect(for: textContainer))
        let offsetX = (labelSize.width - textBoundingBox.size.width) * label.offsetXDivisor - textBoundingBox.origin.x
        let offsetY = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let locationOfTouch = CGPoint(
            x: touchLocation.x - offsetX,
            y: touchLocation.y - offsetY
        )
        let indexOfCharacter = self.characterIndex(for: locationOfTouch, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return indexOfCharacter
    }
}
