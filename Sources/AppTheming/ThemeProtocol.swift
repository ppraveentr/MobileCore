//
//  ThemeProtocol.swift
//  MobileCore
//
//  Created by Praveen P on 20/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

import Foundation
import UIKit

// Used for UIView subclasses Type
public protocol ThemeProtocol: AnyObject {
    
    // Retruns 'ThemeStyle' specific to current state of object.
    // Say if UIView is disabled, retrun "disabled", which can be clubed with main Theme style.
    // Eg, if currentTheme is 'viewB', then when disabled state, theme willbe : 'viewB:disabled'
    func getThemeSubType() -> String?
    
    // Custom Subclass can implement, to config Custom component
    func updateTheme(_ theme: ThemeModel)
}

// MARK: UIView
public extension ThemeProtocol where Self: UIView {
    
    // If view is disabled, check for ".disabledStyle" style
    func getThemeSubType() -> String? {
        self.isUserInteractionEnabled ? nil : ThemeStyle.disabledStyle
    }
    
    // Color
    func getColor(_ colorName: String?) -> UIColor? {
        ThemesManager.getColor(colorName)
    }
    
    // font
    func getFont(_ fontName: String?) -> UIFont? {
        ThemesManager.getFont(fontName)
    }
}

// MARK: ControlThemeProtocol
// Used for UIControl objects, when multiple states are possible to set at initalization
public protocol ControlThemeProtocol: ThemeProtocol {
    
    func getAllThemeSubType() -> Bool
    func setThemes(_ themes: ThemeModel)
    func update(themeDic: ThemeModel, state: UIControl.State)
}

extension ControlThemeProtocol {
    public func updateTheme(_ theme: ThemeModel) {
        // Optional Protocol implementation: intentionally empty
    }
}
