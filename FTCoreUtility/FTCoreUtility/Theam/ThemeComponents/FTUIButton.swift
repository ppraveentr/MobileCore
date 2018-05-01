//
//  FTUIButton.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUIButton: UIButton, FTUIControlThemeProtocol {

    //check view state, to update style
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
    
    public func updateTheme(_ theme: FTThemeDic) {
        
    }
    
    //For custome key:value pairs
    public func update(themeDic: FTThemeDic, state: UIControlState) {
        
        for (kind, value) in themeDic {
            switch kind {
            case "textcolor":
                let colorName: String? = value as? String
                let color = FTThemesManager.getColor(colorName)
                
                if let color = color {
                    self.setTitleColor(color, for: state)
                    //TODO: For attributed title
                }

            case "image":
                if let image = FTThemesManager.getImage(value) {
                    self.setImage(image, for: state)
                }

            default:
                break
            }
        }
    }
}
