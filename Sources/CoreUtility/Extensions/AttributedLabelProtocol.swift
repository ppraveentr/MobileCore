//
//  AttributedLabelProtocol.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen P on 20/10/19.
//

import Foundation
import UIKit

public typealias LabelLinkHandler = (LinkHandlerModel) -> Void

// For Visual update of 'Theme' & 'attributedText'
public protocol OptionalLayoutSubview {
    func updateVisualThemes()
}

protocol AttributedLabelProtocol where Self: UILabel {
    // Link handler
    var linkRanges: [LinkHandlerModel]? { get set }
    var linkHandler: LabelLinkHandler? { get set }
    var tapGestureRecognizer: UITapGestureRecognizer { get }
    // layout
    var layoutManager: NSLayoutManager { get }
    var styleProperties: AttributedDictionary { get set }
}

private extension AssociatedKey {
    static var textContainer = "textContainer"
    static var layoutManager = "layoutManager"
    static var styleProperties = "styleProperties"

    static var linkRanges = "linkRanges"
    static var islinkDetectionEnabled = "islinkDetectionEnabled"
    static var isLinkUnderLineEnabled = "isLinkUnderLineEnabled"
    static var linkHandler = "linkHandler"
    static var tapGestureRecognizer = "tapGestureRecognizer"
}

extension UILabel: AttributedLabelProtocol {
    public var linkRanges: [LinkHandlerModel]? {
        get { AssociatedObject.getAssociated(self, key: &AssociatedKey.linkRanges) }
        set { AssociatedObject<[LinkHandlerModel]>.setAssociated(self, value: newValue, key: &AssociatedKey.linkRanges) }
    }
    
    // LabelThemeProperyProtocol
    public var islinkDetectionEnabled: Bool {
        get { AssociatedObject.getAssociated(self, key: &AssociatedKey.islinkDetectionEnabled) { true }! }
        set { AssociatedObject<Bool>.setAssociated(self, value: newValue, key: &AssociatedKey.islinkDetectionEnabled) }
    }
    
    public var isLinkUnderLineEnabled: Bool {
        get { AssociatedObject.getAssociated(self, key: &AssociatedKey.isLinkUnderLineEnabled) { false }! }
        set { AssociatedObject<Bool>.setAssociated(self, value: newValue, key: &AssociatedKey.isLinkUnderLineEnabled) }
    }
    
    public var linkHandler: LabelLinkHandler? {
        get { AssociatedObject.getAssociated(self, key: &AssociatedKey.linkHandler) }
        set {
            AssociatedObject<LabelLinkHandler>.setAssociated(self, value: newValue, key: &AssociatedKey.linkHandler)
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    public var tapGestureRecognizer: UITapGestureRecognizer {
        AssociatedObject.getAssociated(self, key: &AssociatedKey.tapGestureRecognizer) { UILabel.tapGesture(targer: self) }!
    }
    
    public var layoutManager: NSLayoutManager {
        AssociatedObject.getAssociated(self, key: &AssociatedKey.layoutManager) { NSLayoutManager() }!
    }
    
    public var textContainer: NSTextContainer {
        let local: NSTextContainer = AssociatedObject.getAssociated(self, key: &AssociatedKey.textContainer) { self.getTextContainer() }!
        local.lineFragmentPadding = 0.0
        local.maximumNumberOfLines = self.numberOfLines
        local.lineBreakMode = self.lineBreakMode
        local.widthTracksTextView = true
        local.heightTracksTextView = true
        local.size = self.bounds.size
        return local
    }
    
    public var styleProperties: AttributedDictionary {
        get { AssociatedObject.getAssociated(self, key: &AssociatedKey.styleProperties) { self.defaultStyleProperties }! }
        set { AssociatedObject<AttributedDictionary>.setAssociated(self, value: newValue, key: &AssociatedKey.styleProperties) }
    }
    
    public var htmlText: String {
        get { "" }
        set { updateWithHtmlString(text: newValue) }
    }
}

extension UILabel: OptionalLayoutSubview {
    @objc
    public func updateVisualThemes() {
        if islinkDetectionEnabled, self.text.isHTMLString, let newValue = self.text {
            self.text = newValue.stripHTML()
            self.numberOfLines = 0
            updateWithHtmlString(text: newValue)
        }
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
    
    private var defaultStyleProperties: AttributedDictionary {
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.alignment = self.textAlignment
        paragrahStyle.lineBreakMode = self.lineBreakMode
        
        var properties: AttributedDictionary = [
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
        let att = text?.htmlAttributedString()
        self.updateTextWithAttributedString(attributedString: att)
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
        self.linkRanges = LinkHandlerModel.appendLink(attributedString: attributedString)
    }
    
    // MARK: Container SetUp
    func layoutTextView() {
        updateTextContainerSize()
        layoutView()
    }
    
    public func didTapAttributedText(_ gesture: UIGestureRecognizer) -> [LinkHandlerModel]? {
        let indexOfCharacter = layoutManager.indexOfCharacter(self, touchLocation: gesture.location(in: self))
        return self.linkRanges?.filter { $0.linkRange.contains(indexOfCharacter) }
    }
    
    // MARK: Text Sanitizing
    func sanitizeAttributedString(attributedString: NSAttributedString) -> NSMutableAttributedString {
        guard attributedString.length != 0 else { return attributedString.mutableString() }
        var range = attributedString.nsRange()
        guard let praStryle = attributedString.attribute(.paragraphStyle, at: 0, effectiveRange: &range) as? NSParagraphStyle,
              let mutablePraStryle = praStryle.mutableCopy() as? NSMutableParagraphStyle else {
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
        let locationOfTouch = CGPoint(x: touchLocation.x - offsetX, y: touchLocation.y - offsetY)
        let indexOfCharacter = self.characterIndex(for: locationOfTouch, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return indexOfCharacter
    }
}
