//
//  Math+Extension.swift
//  MobileCore-CoreUtility
//
//  Created by Praveen Prabhakar on 19/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

public func ceil(size: CGSize) -> CGSize {
    CGSize(width: ceil(size.width), height: ceil(size.height))
}

// Combine 2-diff Size objects and get max values of both
public func maxSize(_ rhs: CGSize, _ lhs: CGSize) -> CGSize {
    CGSize(
        width: max(rhs.width, lhs.width),
        height: max(rhs.height, lhs.height)
    )
}
