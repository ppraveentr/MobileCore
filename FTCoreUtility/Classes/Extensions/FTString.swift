//
//  FTString.swift
//  FTMobileCore
//
//  Created by Praveen Prabhakar on 28/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

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
}

public extension String {

    func isHTMLString() -> Bool {
        if self.range(of: "<[^>]+>", options: .regularExpression) != nil {
            return true
        }
        return false
    }

    func stripHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    func htmlAttributedString() -> NSMutableAttributedString {
        guard self.count > 0 else { return NSMutableAttributedString() }
        guard self.isHTMLString() else { return NSMutableAttributedString(string: self) }
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
        let range = NSRange(location: 0, length: self.count)
        exp?.enumerateMatches(in: self, options: .reportCompletion, range: range) { result, _, _ in
            block?(result)
        }
    }

    // Color
    func hexColor() -> UIColor? {
        return UIColor.hexColor(self)
    }
    
// MARK: String Size
    // Remove's 'sting' from self -> and retruns new 'String'
    // Original value is not affected
    func trimming(string: String) -> String {
        return self.replacingOccurrences(of: string, with: "")
    }
    
    // Remove's 'sting' from self -> and update the 'self'
    @discardableResult
    mutating func trimString(string: String) -> String {
        self = self.replacingOccurrences(of: string, with: "")
        return self
    }
    
    // Remove prefix "string"
    @discardableResult
    mutating func trimPrefix(_ string: String) -> String {
        while self.hasPrefix(string) {
            if let range = self.range(of: string) {
                self.removeSubrange(range)
            }
        }
        return self
    }
    
    // Get subString within the 'range'
    func substring(with range: NSRange) -> String? {
        return (self as NSString).substring(with: range) as String?
    }
    
    // Get subString 'from-index' to 'to-index'
    func substring(from fromIndex: Int, to toIndex: Int) -> String? {
        let range = NSRange(location: fromIndex, length: toIndex - fromIndex)
        let substring = self.substring(with: range)
        return substring
    }
    
    // Verify if self contains a subString
    func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }

    /**
     CGSize of text based.
     */
    func textSize(font: UIFont, constrainedSize: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        guard self.count > 0 else {
            return .zero
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attributes: [NSAttributedString.Key: Any] = [
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
        return try dataAtPath()?.jsonContent() as? T
    }

    // Loading Data from given Path
    func dataAtPath() throws -> Data? {
        return try Data(contentsOf: URL(fileURLWithPath: self))
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
