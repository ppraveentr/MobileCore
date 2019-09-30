//
//  FTImage.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 13/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIImage {
    
    static func named(_ named: String) -> UIImage? {
        return FTThemesManager.getImage(named)
    }
}
