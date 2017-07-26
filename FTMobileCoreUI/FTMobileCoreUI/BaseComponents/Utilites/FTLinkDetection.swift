//
//  String+Utlity.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 16/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public enum FTLinkType {
    case LinkTypeURL
    case LinkTypeHashTag
}

open class FTLinkDetection {
    
    var linkType: FTLinkType
    var linkRange: NSRange?
    
    var linkURL: URL?
    
    init(linkType: FTLinkType, linkRange: NSRange?, linkURL: URL?) {
        self.linkType = linkType
        self.linkRange = linkRange
        self.linkURL = linkURL
    }
    
    public var description : String {
        return "(Type: \(self.linkType), Range: -location \(self.linkRange!.location), -length \(self.linkRange!.length), URL: \(self.linkURL!))"
    }
        
    public static func getURLLinkRanges(_ text: String) -> [FTLinkDetection] {
        
        var rangeOfURL = [FTLinkDetection]()
        
        let types: NSTextCheckingResult.CheckingType = [ .link, .phoneNumber]
        let detector = try? NSDataDetector(types: types.rawValue)
        
        detector?.enumerateMatches(in: text, options: [], range: NSMakeRange(0, (text as NSString).length)) { (result, flags, _) in
            
            if(result?.url != nil){
                let dec = FTLinkDetection(linkType: .LinkTypeURL, linkRange: result?.range, linkURL: result?.url)
                rangeOfURL.append(dec)
            }
        }
        
        return rangeOfURL
    }
    
    public static func getHashTagRanges(_ text: String) -> [FTLinkDetection] {
        
        var rangeOfURL = [FTLinkDetection]()
        
        let regHash = try? NSRegularExpression.init(pattern: "(?<!\\w)#([\\w]+)", options: .caseInsensitive)
        
        regHash?.enumerateMatches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.characters.count)) { (result, flags, _) in
            
            if let range = result?.range, let subText = (text as NSString).substring(with: NSMakeRange(range.location, range.length)) as String! {
                
                let dec = FTLinkDetection(linkType: .LinkTypeHashTag, linkRange: range, linkURL: URL(string: subText))
                rangeOfURL.append(dec)
            }
        }
        
        return rangeOfURL
    }
}

