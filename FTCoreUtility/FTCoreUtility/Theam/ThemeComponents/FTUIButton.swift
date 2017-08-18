//
//  FTUIButton.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUIButton: UIButton, FTThemeProtocol {

    public func get_AllThemeSubType() -> Bool { return true }
    
    public func get_ThemeSubType() -> String? {
        if self.isEnabled {
            return nil
        }
        else if self.isSelected {
            return ThemeStyle.selectedStyle
        }
        else if self.isHighlighted {
            return ThemeStyle.highlightedStyle
        }
        else{
            return ThemeStyle.disabledStyle
        }
    }
    
    public func setThemes(_ themes: FTThemeDic) {
        
        for (kind, value) in themes {
            
            guard let theme = value as? FTThemeDic else { continue }
            
            switch kind {
                
            case ThemeStyle.defaultStyle:
                self.update(themeDic: theme, state: .normal)
                break
                
            case ThemeStyle.disabledStyle:
                self.update(themeDic: theme, state: .disabled)
                break
                
            case ThemeStyle.highlightedStyle:
                self.update(themeDic: theme, state: .highlighted)
                break
                
            case ThemeStyle.selectedStyle:
                self.update(themeDic: theme, state: .selected)
                break
                
            default:
                break
            }
        }
    }
   
    public func updateTheme(_ themeDic: FTThemeDic) {
        let themeDic = [self.get_ThemeSubType() ?? ThemeStyle.defaultStyle : themeDic]
        self.setThemes(themeDic)
    }
    
    func update(themeDic: FTThemeDic, state: UIControlState) {
        
        for (kind, value) in themeDic {
            
            switch kind {
                
            case "textcolor":
                let colorName: String? = value as? String
                let color = FTThemesManager.getColor(colorName)
                
                if let color = color {
                    self.setTitleColor(color, for: state)
                }
                
            default:
                break
            }
        }
    }
    
}
