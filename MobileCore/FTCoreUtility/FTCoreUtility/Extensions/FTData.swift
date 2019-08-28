//
//  FTData.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 11/04/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension Data {

    func jsonContent() -> Any? {
        do {
            let content = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            return content
        }
        catch {
            ftLog(error)
        }
        return nil
    }

    // Data decoder based on resposne mimeType or defaluts to [.utf8, .unicode]
    func decodeToString(encodingList: [String.Encoding] = [.utf8, .unicode]) -> String? {

        var html: String?

        // Try to decode the String
        for type in encodingList {
            html = String(bytes: self, encoding: type)
            if html != nil {
                break
            }
        }
        
        //Try: On nil, try getting encoding list from URLResponse
        
        return (html)
    }
}
