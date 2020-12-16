//
//  String+Extension.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 28/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias AttributedDictionary = [NSAttributedString.Key: Any]

private enum RegularExpression {
    static let htmlFormat = "<[^>]+>"
}
// Since all optionals are actual enum values in Swift,
public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
        case let string?:
            return string.isEmpty
        case nil:
            return true
        }
    }
    var isHTMLString: Bool {
        if let strongSelf = self {
            return strongSelf.isHTMLString
        }
        return false
    }
}

public extension String {
    var isHTMLString: Bool {
        if self.range(of: RegularExpression.htmlFormat, options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    func stripHTML() -> String {
        self.replacingOccurrences(of: RegularExpression.htmlFormat, with: "", options: .regularExpression, range: nil)
    }

    func htmlAttributedString() -> NSMutableAttributedString {
        guard !self.isEmpty else { return NSMutableAttributedString() }
        guard self.isHTMLString else { return NSMutableAttributedString(string: self) }
        guard let data = data(using: .utf8, allowLossyConversion: true) else {
            return NSMutableAttributedString()
        }
        
        do {
            return try NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        }
        catch {
            return NSMutableAttributedString()
        }
    }

    // Enmuration
    func enumerate(pattern: String, using block: ((NSTextCheckingResult?) -> Void )? ) {
        let exp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = self.nsRange()
        exp?.enumerateMatches(in: self, options: .reportCompletion, range: range) { result, _, _ in
            block?(result)
        }
    }

    // Color
    func hexColor() -> UIColor? {
        UIColor.hexColor(self)
    }
    
// MARK: String Size
    // Remove's 'sting' from self -> and retruns new 'String'
    // Original value is not affected
    func trimming(_ string: String) -> String {
        self.replacingOccurrences(of: string, with: "")
    }
    
    @discardableResult
    mutating func trimming(_ strings: [String]) -> String {
        strings.forEach { str in
            self = self.replacingOccurrences(of: str, with: "")
        }
        return self
    }
    
    // Remove prefix "string"
    mutating func trimPrefix(_ string: String) {
        while self.hasPrefix(string) {
            if let range = self.range(of: string) {
                self.removeSubrange(range)
            }
        }
    }
    
    func trimingPrefix(_ string: String) -> String {
        var obj = String(self)
        while obj.hasPrefix(string) {
            if let range = obj.range(of: string) {
                obj.removeSubrange(range)
            }
        }
        return obj
    }
    
    // Range
    func nsRange(from: Int = 0) -> NSRange {
        NSRange(location: from, length: self.count)
    }
    
    // Get subString within the 'range'
    func substring(with range: NSRange) -> String? {
        (self as NSString).substring(with: range) as String?
    }
    
    // Get subString 'from-index' to 'to-index'
    func substring(from: Int, to: Int) -> String? {
        let range = NSRange(location: from, length: to - from)
        let substring = self.substring(with: range)
        return substring
    }
    
    // Verify if self contains a subString
    func contains(_ find: String) -> Bool {
        self.range(of: find) != nil
    }

    /**
     CGSize of text based.
     */
    func textSize(font: UIFont, constrainedSize: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        guard !self.isEmpty else {
            return .zero
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attributes: AttributedDictionary = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        let size = attributedString.boundingRect(
            with: constrainedSize,
            options: [.usesDeviceMetrics, .usesLineFragmentOrigin, .usesFontLeading],
            context: nil
            ).size
        
        return ceil(size: size)
    }
    
// MARK: JSON
    // Loading Data from given Path
    func jsonContentAtPath<T>() throws -> T? {
        try dataAtPath()?.jsonContent() as? T
    }

    // Loading Data from given Path
    func dataAtPath() throws -> Data? {
        try Data(contentsOf: URL(fileURLWithPath: self))
    }

    // MARK: File
    // Loading Data from given Path
    func filesAtPath(_ fileAtPath: @escaping (_ path: String) -> Void ) throws {
        let fileManger = FileManager.default
        do {
            let filelist = try fileManger.contentsOfDirectory(atPath: self)
            _ = filelist.map {
                fileAtPath( (self + "/\($0)") )
            }
        }
        catch {
            if fileManger.contents(atPath: self) != nil {
                fileAtPath(self)
            }
        }
    }

    // MARK: Bundle
    func bundleURL(extention: String = ".bundle") -> URL? {
        var value = self
        if !value.hasSuffix(extention) {
            value.append(extention)
        }
        return Bundle.main.resourceURL?.appendingPathComponent(value)
    }
    
    func bundle() -> Bundle? {
        if let bundleURL = self.bundleURL() {
            return Bundle(url: bundleURL)
        }
        return nil
    }
}

public extension NSAttributedString {
    // Range
    func nsRange(from: Int = 0) -> NSRange {
        NSRange(location: from, length: self.length)
    }
    
    func mutableString() -> NSMutableAttributedString {
        if let value = self.mutableCopy() as? NSMutableAttributedString {
            return value
        }
        return NSMutableAttributedString()
    }
}

public extension NSMutableAttributedString {
    func addParagraphStyle(style: NSMutableParagraphStyle) {
        let range = self.nsRange()
        self.addAttribute(.paragraphStyle, value: style, range: range)
    }
}
