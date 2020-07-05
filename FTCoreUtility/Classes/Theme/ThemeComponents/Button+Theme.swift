//
//  Button+Extension.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

extension UIButton: ControlThemeProtocol {
    // check view state, to update style
    open func getThemeSubType() -> String? {
        if self.isEnabled {
            return nil
        }
        else if self.isSelected {
            return ThemeStyle.selectedStyle
        }
        else if self.isHighlighted {
            return ThemeStyle.highlightedStyle
        }
        
        return ThemeStyle.disabledStyle
    }
    
    // For custome key:value pairs
    open func update(themeDic: ThemeModel, state: UIControl.State) {
        
        if
            let text = themeDic["textcolor"] as? String,
            let color = ThemesManager.getColor(text)
        {
            self.setTitleColor(color, for: state)
            // TODO: For attributed title
        }
        
        if
            let text = themeDic["textfont"] as? String,
            let font = ThemesManager.getFont(text)
        {
            self.titleLabel?.font = font
        }
        
        if let image = ThemesManager.getImage(themeDic["image"]) {
            self.setImage(image, for: state)
        }
    }
}
