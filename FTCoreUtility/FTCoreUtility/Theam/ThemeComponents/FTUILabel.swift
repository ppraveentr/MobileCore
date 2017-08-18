//
//  FTUILabel.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUILabel: UILabel, FTThemeProtocol {
    
    public func updateTheme(_ theme: FTThemeDic) {
        self.updateVisualThemes()
    }

    public func get_ThemeSubType() -> String? {
        return self.isEnabled ? nil : ThemeStyle.disabledStyle
    }
    
    open func theme_isLinkUnderlineEnabled(_ bool: Bool) {
        if var labelTheme = self as? FTUILabelThemeProtocol {
            labelTheme.theme_linkUndelineEnabled = bool
        }
    }
    
    open func theme_isLinkDetectionEnabled(_ bool: Bool) {
        if var labelTheme = self as? FTUILabelThemeProtocol {
            labelTheme.theme_linkDetectionEnabled = bool
        }
    }
    
    open func theme_textfont(_ font: UIFont) { self.font = font }
    
    open func theme_textcolor(_ color: UIColor) { self.textColor = color }
    
    open func theme_backgroundColor(_ color: UIColor) { self.backgroundColor = color }
    
    public func updateVisualThemes() {
        
        //Force update
        if let text = self.attributedText {
            self.attributedText = text
        }else if let text = self.text {
            self.text = text
        }
    }
}
