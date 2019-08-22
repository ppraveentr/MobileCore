//
//  FTView+Utiltiy.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 20/10/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIView {

    func addBorder(color: UIColor = .lightGray, borderWidth: CGFloat = 1.5) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
}
