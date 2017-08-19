//
//  FTMath.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public func FTCeilForSize(_ size: CGSize) -> CGSize {
    return CGSize(width: ceil(size.width), height: ceil(size.height))
}

public func FTMaxSize(_ rhs: CGSize,_ lhs: CGSize) -> CGSize {
    return CGSize(width: max(rhs.width, lhs.width),
           height: max(rhs.height, lhs.height))
}

public func FTSizeMax() -> CGSize {
    return CGSize(width: CGFloat.greatestFiniteMagnitude,
                  height: CGFloat.greatestFiniteMagnitude)
}

