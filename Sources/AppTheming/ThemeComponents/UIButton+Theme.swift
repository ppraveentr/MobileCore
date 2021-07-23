//
//  UIButton+Theme.swift
//  MobileCore-AppTheming
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

extension UIButton: ControlThemeProtocol {
    // check view state, to update style
    open func subStyleName() -> ThemeStyle? {
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
        
        if let color = ThemesManager.getColor(themeDic[ThemeType.Key.textcolor] as? String) {
            self.setTitleColor(color, for: state)
            // For attributed title
            attribute.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        if let text = themeDic[ThemeType.Key.textfont] as? String,
           let font = ThemesManager.getFont(text) {
            self.titleLabel?.font = font
            // For attributed title
            attribute.addAttribute(.font, value: font, range: range)
        }
        
        if let underline = themeDic[ThemeType.Key.underline] as? ThemeModel {
            if let color = ThemesManager.getColor(underline[ThemeType.color] as? String) {
                attribute.addAttribute(.underlineColor, value: color, range: range)
            }
            if let intValue = underline[ThemeType.Key.style] as? Int {
                let style = NSUnderlineStyle(rawValue: intValue).rawValue
                attribute.addAttribute(.underlineStyle, value: style, range: range)
            }
        }
        
        if let image = ThemesManager.getImage(themeDic[ThemeType.Key.image]) {
            self.setImage(image, for: state)
        }
        
        self.setAttributedTitle(attribute, for: state)
    }
}
