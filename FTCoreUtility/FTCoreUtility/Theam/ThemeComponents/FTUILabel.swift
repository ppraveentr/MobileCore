//
//  FTUILabel.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUILabel: UILabel, FTThemeProtocol {
    
    //Force update theme attibute
    public func updateTheme(_ theme: FTThemeDic) {
        self.updateVisualThemes()
    }

    //If view is disabled, check for ".disabledStyle" style
    public func get_ThemeSubType() -> String? {
        return self.isEnabled ? nil : ThemeStyle.disabledStyle
    }
    
    //Should underline hyper-link
    open func theme_isLinkUnderlineEnabled(_ bool: Bool) {
        if var labelTheme = self as? FTUILabelThemeProperyProtocol {
            labelTheme.theme_linkUndelineEnabled = bool
        }
    }
    
    //should allow detecction for hyper-link
    open func theme_isLinkDetectionEnabled(_ bool: Bool) {
        if var labelTheme = self as? FTUILabelThemeProperyProtocol {
            labelTheme.theme_linkDetectionEnabled = bool
        }
    }
    
    //text font
    open func theme_textfont(_ font: UIFont) { self.font = font }
    
    //text font color
    open func theme_textcolor(_ color: UIColor) { self.textColor = color }
    
    //text background color
    open func theme_backgroundColor(_ color: UIColor) { self.backgroundColor = color }
    
    //Force Update text with same value to trigger Theme changes  
    public func updateVisualThemes() {
        
        //Force update
        if let text = self.attributedText {
            self.attributedText = text
        }else if let text = self.text {
            self.text = text
        }
    }
}
