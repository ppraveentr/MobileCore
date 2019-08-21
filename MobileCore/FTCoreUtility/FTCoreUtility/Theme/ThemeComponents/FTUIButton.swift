//
//  FTUIButton.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 18/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTUIButton: UIButton, FTUIControlThemeProtocol {

    // check view state, to update style
    public func getThemeSubType() -> String? {
        if self.isEnabled {
            return nil
        }
        else if self.isSelected {
            return FTThemeStyle.selectedStyle
        }
        else if self.isHighlighted {
            return FTThemeStyle.highlightedStyle
        }
        else {
            return FTThemeStyle.disabledStyle
        }
    }
    
    // For custome key:value pairs
    public func update(themeDic: FTThemeModel, state: UIControl.State) {

        if
            let text = themeDic["textcolor"] as? String,
            let color = FTThemesManager.getColor(text)
        {
                self.setTitleColor(color, for: state)
                // TODO: For attributed title
        }

        if
            let text = themeDic["textfont"] as? String,
            let font = FTThemesManager.getFont(text)
        {
            self.titleLabel?.font = font
        }

        if let image = FTThemesManager.getImage(themeDic["image"]) {
                self.setImage(image, for: state)
        }
    }
}
