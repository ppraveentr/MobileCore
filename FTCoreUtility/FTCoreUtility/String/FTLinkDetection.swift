//
//  String+Utlity.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 16/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTLinkDetection {

    enum FTLinkType {
        case LinkTypeURL
        case LinkTypeHashTag
    }
    
    var linkType: FTLinkType
    var linkRange: NSRange
    
    var linkURL: URL
    
    init(linkType: FTLinkType, linkRange: NSRange, linkURL: URL) {
        self.linkType = linkType
        self.linkRange = linkRange
        self.linkURL = linkURL
    }
    
    public var description : String {
        return "(Type: \(self.linkType), Range: -location \(self.linkRange.location), -length \(self.linkRange.length), URL: \(self.linkURL))"
    }
    
    //Get list of FTLinkDetection from the String
    public static func getURLLinkRanges(_ text: String) -> [FTLinkDetection] {
        
        var rangeOfURL = [FTLinkDetection]()
        
        let types: NSTextCheckingResult.CheckingType = [ .link, .phoneNumber]
        let detector = try? NSDataDetector(types: types.rawValue)
        
        detector?.enumerateMatches(in: text, options: [], range: NSMakeRange(0, (text as NSString).length)) { (result, flags, _) in
            
            if
                let url = result?.url,
                let range = result?.range {
                    let dec = FTLinkDetection(linkType: .LinkTypeURL, linkRange: range, linkURL: url)
                    rangeOfURL.append(dec)
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
        
        //Hi #wellcome thanks.
        //Here, "#wellcome" is retuned
        text.enumerate(pattern: "(?<!\\w)#([\\w]+)") { (result) in
            
            if
                let range = result?.range,
                let subText = (text as NSString).substring(with: NSMakeRange(range.location, range.length)) as String!,
                let url = URL(string: subText) {
                    let dec = FTLinkDetection(linkType: .LinkTypeHashTag, linkRange: range, linkURL: url)
                    rangeOfURL.append(dec)
            }
        }
        
        return rangeOfURL
    }
}

