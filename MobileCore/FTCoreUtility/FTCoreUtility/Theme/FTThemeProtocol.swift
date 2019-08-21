//
//  FTThemeProtocol.swift
//  MobileCore
//
//  Created by Praveen P on 20/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

import Foundation

// Used for UIView subclasses Type
public protocol FTThemeProtocol: AnyObject {
    
    // Retruns 'ThemeStyle' specific to current state of object.
    // Say if UIView is disabled, retrun "disabled", which can be clubed with main Theme style.
    // Eg, if currentTheme is 'viewB', then when disabled state, theme willbe : 'viewB:disabled'
    func getThemeSubType() -> String?
    
    // Custom Subclass can implement, to config Custom component
    func updateTheme(_ theme: FTThemeModel)
}

// MARK: UIView
public extension FTThemeProtocol where Self: UIView {
    
    func getThemeSubType() -> String? {
        // If view is disabled, check for ".disabledStyle" style
        return self.isUserInteractionEnabled ? nil : FTThemeStyle.disabledStyle
    }
    
    // Color
    func getColor(_ colorName: String?) -> UIColor? {
        return FTThemesManager.getColor(colorName)
    }
    
    // Font
    func getFont(_ fontName: String?) -> UIFont? {
        return FTThemesManager.getFont(fontName)
    }
}

// MARK: FTUIControlThemeProtocol
// Used for UIControl objects, when multiple states are possible to set at initalization
public protocol FTUIControlThemeProtocol: FTThemeProtocol {
    
    func getAllThemeSubType() -> Bool
    func setThemes(_ themes: FTThemeModel)
    func update(themeDic: FTThemeModel, state: UIControl.State)
}

extension FTUIControlThemeProtocol {
    public func updateTheme(_ theme: FTThemeModel) {
    }
}
