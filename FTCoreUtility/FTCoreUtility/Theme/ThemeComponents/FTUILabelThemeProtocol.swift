//
//  FTUILabel.swift
//  FTMobileCoreUI
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

// Propery variable to store theme's value.
public protocol FTUILabelThemeProperyProtocol: AnyObject {
    var islinkDetectionEnabled: Bool { get set }
    var isLinkUnderLineEnabled: Bool { get set }
}

// Used for UIView subclasses Type
protocol FTUILabelThemeProtocol: FTThemeProtocol {
    // aUsed for Label
    func theme_isLinkUnderlineEnabled(_ bool: Bool)
    func theme_isLinkDetectionEnabled(_ bool: Bool)
    func theme_textfont(_ font: UIFont)
    func theme_textcolor(_ color: UIColor)
}

public extension FTThemeProtocol where Self: UILabel {
    
    // If view is disabled, check for ".disabledStyle" style
    func get_ThemeSubType() -> String? {
        return self.isEnabled ? nil : FTThemeStyle.disabledStyle
    }
    
    // Force update theme attibute
    func updateTheme(_ theme: FTThemeModel) {
        
        defer {
            self.updateVisualThemes()
        }
        
        for (kind, value) in theme {
            
            switch kind {
                
            case "isLinkUnderlineEnabled":
                self.theme_isLinkUnderlineEnabled(value as? Bool ?? false)
                
            case "isLinkDetectionEnabled":
                self.theme_isLinkDetectionEnabled(value as? Bool ?? false)
                
            case "textfont":
                
                if let font = getFont(value as? String) {
                    self.theme_textfont(font)
                }
                
            case "textcolor":
                if let color = getColor(value as? String) {
                    self.theme_textcolor(color)
                }
                
            default:
                break
            }

        }

    }
    
}

extension UILabel: FTUILabelThemeProtocol {
    
    // Should underline hyper-link
    open func theme_isLinkUnderlineEnabled(_ bool: Bool) {
        if let labelTheme = self as? FTUILabelThemeProperyProtocol {
            labelTheme.isLinkUnderLineEnabled = bool
        }
    }
    
    // should allow detecction for hyper-link
    open func theme_isLinkDetectionEnabled(_ bool: Bool) {
        if let labelTheme = self as? FTUILabelThemeProperyProtocol {
            labelTheme.islinkDetectionEnabled = bool
        }
    }
    
    // TODO:
    open func theme_isUnderlineNeeded(bool: Bool) {
        
    }
    
    // text font
    open func theme_textfont(_ font: UIFont) { self.font = font }
    
    // text font color
    open func theme_textcolor(_ color: UIColor) { self.textColor = color }
        
    // Force Update text with same value to trigger Theme changes  
    func updateVisualThemes() {
        
        // Force update
        if let text = self.attributedText {
            self.attributedText = text
        } else if let text = self.text {
            self.text = text
        }
    }
    
}
