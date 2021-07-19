//
//  UIImageView+Extension.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen P on 08/04/20.
//  Copyright © 2020 Praveen P. All rights reserved.
//

import UIKit

public typealias ImageViewComletionHandler = (UIImage?) -> Void

public extension UIImageView {
    /**
     Download Image from async in background
     - parameter url: Image's url from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
     */
    func downloadedFrom(_ url: URL,
                        contentMode mode: UIView.ContentMode = .scaleAspectFit,
                        defaultImage: UIImage? = nil,
                        comletionHandler: ImageViewComletionHandler? = nil) {
        // Image's Content mode
        contentMode = mode
        image = nil
        // Download Image from async in background
        url.downloadedImage { image in
            let downloadedImage = image ?? defaultImage
            DispatchQueue.main.async { [weak self] in
                self?.image = downloadedImage
                comletionHandler?(downloadedImage)
            }
        }
    }
}
