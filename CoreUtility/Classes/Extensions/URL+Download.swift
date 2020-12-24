//
//  URL+Extension.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 01/05/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension URL {    
    /**
     Download Image from async in background
     - parameter allowCache: Catches image localy based on URL
     */
    func downloadedImage(using session: URLSession = URLSession.shared,
                         cache: NSCache<AnyObject, UIImage>? = nil,
                         comletionHandler: ImageViewComletionHandler? = nil) {
        // Cache image based on URL
        let cacheKey = absoluteString as NSString
        if let image = cache?.object(forKey: cacheKey) {
            // Update view's image in main thread
            comletionHandler?(image)
            return
        }
        
        let updateCache: ((UIImage?) -> Void) = { image in
            guard let image = image else {
                // remove cached image
                cache?.removeObject(forKey: cacheKey)
                comletionHandler?(nil)
                return
            }
            // Cache image localy
            cache?.setObject(image, forKey: cacheKey)
            // After Image download compeltion
            comletionHandler?(image)
        }
        
        // Setup URLSession
        let task = session.dataTask(with: self) { data, response, error in
            // validate for proper data and imageType
            guard let data: Data = data, error == nil else {
                updateCache(nil)
                return
            }
            // validate for proper data and imageType
            guard let mimeType = response?.mimeType,
                mimeType.hasPrefix("image"),
                let image = UIImage(data: data) else {
                    // remove cached image
                    updateCache(nil)
                    return
            }
            // Cache image localy
            updateCache(image)
        }
        // Stat call
        task.resume()
    }
}
