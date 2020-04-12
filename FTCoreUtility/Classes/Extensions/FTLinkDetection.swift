//
//  String+Utlity.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 16/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTLinkDetection {

    public enum FTLinkType {
        case url
        case hashTag
    }
    
    public var linkType: FTLinkType
    public var linkRange: NSRange
    public var linkURL: URL
    
    init(linkType: FTLinkType, linkRange: NSRange, linkURL: URL) {
        self.linkType = linkType
        self.linkRange = linkRange
        self.linkURL = linkURL
    }
    
    public var description: String {
        "(Type: \(self.linkType), Range: -location \(self.linkRange.location), -length \(self.linkRange.length), URL: \(self.linkURL))"
    }
    
    // Get list of FTLinkDetection from the String
    public static func getURLLinkRanges(_ text: String) -> [FTLinkDetection] {
        
        var rangeOfURL = [FTLinkDetection]()
        
        let types: NSTextCheckingResult.CheckingType = [ .link, .phoneNumber]
        let detector = try? NSDataDetector(types: types.rawValue)
        
        let range = text.nsRange()
        detector?.enumerateMatches(in: text, options: [], range: range) { result, _, _ in
            if
                let url = result?.url,
                let range = result?.range {
                    let dec = FTLinkDetection(linkType: .url, linkRange: range, linkURL: url)
                    rangeOfURL.append(dec)
            }
        }
        
        return rangeOfURL
    }
    
    static let searchKey = NSAttributedString.Key("NSLink")

    // Get list of FTLinkDetection from the NSAttributedString
    public static func getURLLinkRanges(_ text: NSAttributedString) -> [FTLinkDetection] {
        
        var rangeOfURL = [FTLinkDetection]()
        let range = text.string.nsRange()
        text.enumerateAttributes(in: range, options: []) { obj, range, _ in
            obj.forEach { key, value in
                if key == searchKey, let url = value as? URL {
                    let dec = FTLinkDetection(linkType: .url, linkRange: range, linkURL: url)
                    rangeOfURL.append(dec)
                }
            }
        }
        
        return rangeOfURL
    }
    
    /*
     * Eg.) Hi #wellcome thanks.
     * "#wellcome" is the detected-link
     */
    public static func getHashTagRanges(_ text: String) -> [FTLinkDetection] {
        
        var rangeOfURL = [FTLinkDetection]()
        
        // Hi #wellcome thanks.
        // Here, "#wellcome" is retuned
        text.enumerate(pattern: "(?<!\\w)#([\\w]+)") { result in
            if
                let range = result?.range,
                let subText = text.substring(with: range),
                let url = URL(string: subText) {
                    let dec = FTLinkDetection(linkType: .hashTag, linkRange: range, linkURL: url)
                    rangeOfURL.append(dec)
            }
        }
        
        return rangeOfURL
    }
    
    /*
     * Eg.) Hi #wellcome thanks.
     * "#wellcome" is the detected-link
     */
    public static func appendLink(attributedString: NSMutableAttributedString) -> [FTLinkDetection] {
        
        var links = [FTLinkDetection]()
        
        // HTTP links
        let urlLinks = FTLinkDetection.getURLLinkRanges(attributedString)
        links.insert(contentsOf: urlLinks, at: 0)
        
        links.forEach { link in
            let att = getStyleProperties(forLink: link)
            attributedString.addAttributes(att, range: link.linkRange)
        }
        
        // Hash Tags
        let hashLinks = FTLinkDetection.getHashTagRanges(attributedString.string)
        links.insert(contentsOf: hashLinks, at: 0)
        
        hashLinks.forEach { link in
            let att = getStyleProperties(forLink: link)
            attributedString.addAttributes(att, range: link.linkRange)
        }
        
        return links
    }
    
    // TODO: Themes
    public static func getStyleProperties(forLink link: FTLinkDetection) -> FTAttributedStringKey {
        var properties: FTAttributedStringKey = [
            .underlineColor: UIColor.blue,
            .foregroundColor: UIColor.blue
        ]
        if link.linkType == .hashTag {
            properties[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        return properties
    }
}
