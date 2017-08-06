//
//  FTUILabel.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUILabel: UILabel, FTThemeProtocol {
    
    public func get_ThemeSubType() -> String? {
        if self.isEnabled {
            return nil
        }else{
            return "disabled"
        }
    }
    
    open func theme_isUnderlineNeeded(bool: Bool) {
        
    }
    
    public func updateVisualThemes() {
        
        //Force update
        if let text = self.attributedText {
            self.attributedText = text
        }else if let text = self.text {
            self.text = text
        }
    }
}
