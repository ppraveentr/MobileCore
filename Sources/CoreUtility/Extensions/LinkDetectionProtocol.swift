//
//  LinkDetectionProtocol.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 16/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public protocol LinkDetectionProtocol {
    // Get list of LinkDetection from the String
    static func getURLLinkRanges(_ text: String) -> [LinkHandlerModel]
    
    // Get list of LinkDetection from the NSAttributedString
    static func getURLLinkRanges(_ text: NSAttributedString) -> [LinkHandlerModel]
    
    /*
     * Eg.) Hi #wellcome thanks.
     * "#wellcome" is the detected-link
     */
    static func getHashTagRanges(_ text: String) -> [LinkHandlerModel]
    
    /*
     * Eg.) Hi #wellcome thanks.
     * "#wellcome" is the detected-link
     */
    static func appendLink(attributedString: NSMutableAttributedString) -> [LinkHandlerModel]
    
    // TODO: Themes
    static func getStyleProperties(forLink link: LinkHandlerModel) -> AttributedDictionary
}

public class LinkHandlerModel {

    public enum LinkType {
        case url
        case hashTag
    }
    
    public var linkType: LinkType
    public var linkRange: NSRange
    public var linkURL: URL
    
    init(linkType: LinkType, linkRange: NSRange, linkURL: URL) {
        self.linkType = linkType
        self.linkRange = linkRange
        self.linkURL = linkURL
    }
    
    public var description: String {
        "(Type: \(self.linkType), Range: -location \(self.linkRange.location), -length \(self.linkRange.length), URL: \(self.linkURL))"
    }
}

extension LinkHandlerModel: LinkDetectionProtocol {
    // Protocol implementation: intentionally empty
}

public extension LinkDetectionProtocol {
    // Get list of LinkDetection from the String
    static func getURLLinkRanges(_ text: String) -> [LinkHandlerModel] {
        
        var rangeOfURL = [LinkHandlerModel]()
        
        let types: NSTextCheckingResult.CheckingType = [ .link, .phoneNumber]
        let detector = try? NSDataDetector(types: types.rawValue)
        
        let range = text.nsRange()
        detector?.enumerateMatches(in: text, options: [], range: range) { result, _, _ in
            if
                let url = result?.url,
                let range = result?.range {
                    let dec = LinkHandlerModel(linkType: .url, linkRange: range, linkURL: url)
                    rangeOfURL.append(dec)
            }
        }
        
        return rangeOfURL
    }
    
    // Get list of LinkDetection from the NSAttributedString
    static func getURLLinkRanges(_ text: NSAttributedString) -> [LinkHandlerModel] {
        let searchKey = NSAttributedString.Key("NSLink")

        var rangeOfURL = [LinkHandlerModel]()
        let range = text.string.nsRange()
        text.enumerateAttributes(in: range, options: []) { obj, range, _ in
            obj.forEach { key, value in
                if key == searchKey, let url = value as? URL {
                    let dec = LinkHandlerModel(linkType: .url, linkRange: range, linkURL: url)
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
    static func getHashTagRanges(_ text: String) -> [LinkHandlerModel] {
        
        var rangeOfURL = [LinkHandlerModel]()
        
        // Hi #wellcome thanks.
        // Here, "#wellcome" is retuned
        text.enumerate(pattern: "(?<!\\w)#([\\w]+)") { result in
            if
                let range = result?.range,
                let subText = text.substring(with: range),
                let url = URL(string: subText) {
                    let dec = LinkHandlerModel(linkType: .hashTag, linkRange: range, linkURL: url)
                    rangeOfURL.append(dec)
            }
        }
        
        return rangeOfURL
    }
    
    /*
     * Eg.) Hi #wellcome thanks.
     * "#wellcome" is the detected-link
     */
    static func appendLink(attributedString: NSMutableAttributedString) -> [LinkHandlerModel] {
        
        var links = [LinkHandlerModel]()
        
        // HTTP links
        let urlLinks = Self.getURLLinkRanges(attributedString)
        links.insert(contentsOf: urlLinks, at: 0)
        
        links.forEach { link in
            let att = getStyleProperties(forLink: link)
            attributedString.addAttributes(att, range: link.linkRange)
        }
        
        // Hash Tags
        let hashLinks = Self.getHashTagRanges(attributedString.string)
        links.insert(contentsOf: hashLinks, at: 0)
        
        hashLinks.forEach { link in
            let att = getStyleProperties(forLink: link)
            attributedString.addAttributes(att, range: link.linkRange)
        }
        
        return links
    }
    
    // TODO: Themes
    static func getStyleProperties(forLink link: LinkHandlerModel) -> AttributedDictionary {
        var properties: AttributedDictionary = [
            .underlineColor: UIColor.blue,
            .foregroundColor: UIColor.blue
        ]
        if link.linkType == .hashTag {
            properties[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        return properties
    }
}
