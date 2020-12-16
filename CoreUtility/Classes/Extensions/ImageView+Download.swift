//
//  ImageView+Download.swift
//  CoreUIExtensions
//
//  Created by Praveen P on 08/04/20.
//  Copyright © 2020 Praveen P. All rights reserved.
//

import UIKit

public extension UIImageView {
    /**
     Download Image from async in background
     - parameter url: Image's url from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
     */
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit,
                        defaultImage: UIImage? = nil) {
        // Image's Content mode
        contentMode = mode
        image = nil
        // Download Image from async in background
        url.downloadedImage { image in
            DispatchQueue.main.async { [weak self] in
                self?.image = image ?? defaultImage
            }
        }
    }
    
    /**
     Download Image from async in background
     - parameter link: Image's urlString from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
     */
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit,
                        defaultImage: UIImage? = nil) {
        // Validate urlString
        guard let url = URL(string: link) else {
            self.image = defaultImage
            return
        }
        
        // Download image using valid URL
        downloadedFrom(url: url, contentMode: mode, defaultImage: defaultImage)
    }
}
