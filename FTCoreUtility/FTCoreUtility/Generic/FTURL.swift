//
//  FTURL.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 01/05/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension URL {

    /**
     Download Image from async in background
     - parameter url: Image's url from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
     */
    func downloadedImage(_ comletionHandler: FTUIImageViewComletionHandler? = nil) {

        // Setup URLSession
        URLSession.shared.dataTask(with: self) { (data, response, error) in

            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    // If image download fails
                    comletionHandler?(nil)
                    return
            }

            // Update view's image in main thread
            DispatchQueue.main.async() { () in
                //After Image download compeltion
                comletionHandler?(image)
            }

            }.resume()
    }
    
}
