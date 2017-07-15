//
//  FTView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 10/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTView: UIView {

    open override func layoutSubviews() {
        if self.viewLayoutConstraint.autoSizing {
             self.resizeToFitSubviews()   
        }
        super.layoutSubviews()
    }
    
    open override func removeFromSuperview() {
        self.superview?.setNeedsLayout()
        self.superview?.setNeedsUpdateConstraints()
        self.superview?.layoutSubviews()
        super.removeFromSuperview()
    }
}
