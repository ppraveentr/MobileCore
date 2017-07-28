//
//  UIView+FTConstraint.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 08/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public extension UIView {
    
    func getBaseView() -> UIView? {
        
        if let baseView: FTBaseView = self.superview as? FTBaseView {
            return baseView.mainPinnedView
        }
        
        return nil
    }
}
