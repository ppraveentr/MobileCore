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
    
    //Enmuration
    func enumerate(pattern: String, using block: ((NSTextCheckingResult?) -> Void )? ) {
        
        let exp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        exp?.enumerateMatches(in: self,
                              options: .reportCompletion,
                              range: NSMakeRange(0, self.length),
                              using: { (result, flags, _) in
                                block?(result)
        })
    }

    //Color
    func hexColor() -> UIColor? {
        return UIColor.hexColor(self)
    }
    
//MARK: String Size
    
    //Remove's 'sting' from self -> and retruns new 'String'
    //Original value is not affected
    func trimming(string: String) -> String {
        guard string.length > 0 else { return self}
        return self.replacingOccurrences(of: string, with: "")
    }
    
    //Remove's 'sting' from self -> and update the 'self'
    @discardableResult
    mutating func trimString(string: String) -> String {
        guard string.length > 0 else { return self}
        self = self.replacingOccurrences(of: string, with: "")
        
        return self
    }
    
    //Remove prefix "string"
    @discardableResult
    mutating func trimPrefix(_ string: String) -> String {
        
        guard string.length > 0 else { return self}
        
        while self.hasPrefix(string) {
            let range: Range<String.Index> = self.range(of: string)!
            self.removeSubrange(range)
        }
        
        return self
    }
    
    //Get subString within the 'range'
    func substring(with range: NSRange) -> String? {
        return (self as NSString).substring(with: range) as String! ?? nil
    }
    
    //Get subString 'from-index' to 'to-index'
    func substring(from fromIndex: Int, to toIndex: Int) -> String? {
        let substring = self.substring(with: NSMakeRange(fromIndex, toIndex - fromIndex))
        return substring
    }
    
    //Verify if self contains a subString
    func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    //Length of string or no of characters in self
    var length: Int {
        return self.count
    }

//MARK: JSON
    
    //Loading Data from given Path
    func jsonContentAtPath<T>() throws -> T? {
        
        guard let content = try? Data.init(contentsOf: URL(fileURLWithPath: self)) else {
            return nil
        }
        
        return try JSONSerialization.jsonObject(with: content, options: .allowFragments) as? T
    }
    
    //MARK: File
    //Loading Data from given Path
    func filesAtPath(_ fileAtPath: @escaping (_ path: String) -> () ) throws {
        let fileManger = FileManager.default
        do {
            let filelist = try fileManger.contentsOfDirectory(atPath: self)
            _ = filelist.map({ fileAtPath((self + "/\($0)")) })
        } catch {
            if fileManger.contents(atPath: self) != nil {
                fileAtPath(self)
            }
        }
    }
}
