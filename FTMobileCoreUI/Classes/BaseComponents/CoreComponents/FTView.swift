//
//  FTView.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 10/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTView: UIView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        if self.viewLayoutConstraint.autoSizing {
             self.resizeToFitSubviews()   
        }
    }
}
