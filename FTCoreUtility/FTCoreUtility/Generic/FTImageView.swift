//
//  FTImageView.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 21/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTUIImageViewComletionHandler = ((UIImage?) -> Void)

public extension UIImageView {
    
    /**
     Download Image from async in background
     - parameter url: Image's url from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
     */
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit,
                        comletionHandler: FTUIImageViewComletionHandler? = nil) {
        
        //Image's Content mode
        contentMode = mode

        //Download Image from async in background
        url.downloadedImage { (image) in
            self.image = image
            comletionHandler?(image)
        }
    }
    
    /**
     Download Image from async in background
     - parameter link: Image's urlString from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
     */
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, comletionHandler: FTUIImageViewComletionHandler? = nil) {
        
        //Validate urlString
        guard let url = URL(string: link) else { return }
        
        //Download image using valid URL
        downloadedFrom(url: url, contentMode: mode, comletionHandler: comletionHandler)
    }
}
