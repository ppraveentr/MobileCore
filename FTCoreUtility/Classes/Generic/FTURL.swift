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
        let sesstion = URLSession.shared.dataTask(with: self) { data, _, error in
            guard let data: Data = data, error == nil else { return }
            let image: UIImage? = UIImage(data: data)
            // Update view's image in main thread
            DispatchQueue.main.async {
                // After Image download compeltion
                comletionHandler?(image)
            }
        }
        sesstion.resume()
    }
}
