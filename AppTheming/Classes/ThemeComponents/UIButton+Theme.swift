//
//  UIButton+Theme.swift
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
        let text = self.title(for: state) ?? ""
        let range = NSRange(location: 0, length: text.count)
        let attribute = NSMutableAttributedString(string: text)
        
        if let color = ThemesManager.getColor(themeDic[ThemeKey.textcolor] as? String) {
            self.setTitleColor(color, for: state)
            // For attributed title
            attribute.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        if let text = themeDic[ThemeKey.textfont] as? String,
           let font = ThemesManager.getFont(text) {
            self.titleLabel?.font = font
            // For attributed title
            attribute.addAttribute(.font, value: font, range: range)
        }
        
        if let underline = themeDic[ThemeKey.underline] as? ThemeModel {
            if let color = ThemesManager.getColor(underline[ThemesType.color] as? String) {
                attribute.addAttribute(.underlineColor, value: color, range: range)
            }
            if let intValue = underline[ThemeKey.style] as? Int {
                let style = NSUnderlineStyle(rawValue: intValue).rawValue
                attribute.addAttribute(.underlineStyle, value: style, range: range)
            }
        }
        
        if let image = ThemesManager.getImage(themeDic[ThemeKey.image]) {
            self.setImage(image, for: state)
        }
        
        self.setAttributedTitle(attribute, for: state)
    }
}
