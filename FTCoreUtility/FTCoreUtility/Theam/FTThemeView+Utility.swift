//
//  FTThemeView+Utility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

extension UIView {
    
    class func __setupThemes__() {        
        FTInstanceSwizzling(self, #selector(layoutSubviews), #selector(swizzled_layoutSubviews))
    }
    
    func swizzled_layoutSubviews() {
        if self.needsThemesUpdate {
            self.__updateVisualThemes__()
        }
        self.swizzled_layoutSubviews()
    }
    
    fileprivate static let aoThemes = FTAssociatedObject<String>()
    fileprivate static let aoThemesNeedsUpdate = FTAssociatedObject<Bool>()

    fileprivate final func __updateVisualThemes__() {
        self.needsThemesUpdate = false
        self.generateVisualThemes()
    }
}

public extension UIView {
    
    @IBInspectable
    public final var theme: String? {
        get { return UIView.aoThemes[self] }
        set {
            UIView.aoThemes[self] = newValue
            self.needsThemesUpdate = true
        }
    }
    
    public final var needsThemesUpdate: Bool {
        get { return UIView.aoThemesNeedsUpdate[self] ?? false }
        set {
            UIView.aoThemesNeedsUpdate[self] = newValue
            if newValue {
                self.setNeedsLayout()
                self.generateVisualThemes()
            }
        }
    }
    
    fileprivate func generateVisualThemes() {
        
        guard let (className, themeName) = self.get_ThemeName() else { return }
        
        let delegate: FTThemeProtocol? = self as? FTThemeProtocol
        
        guard let themeDic = FTThemesManager.generateVisualThemes(forClass: className,
                                                                  withStyleName: themeName,
                                                                  withSubStyleName: delegate?.get_ThemeSubType())
            else { return }
        
        self.swizzled_updateTheme(themeDic)
    }
    
    fileprivate func get_ThemeName() -> (String, String)? {
        guard
            let className = get_classNameAsString(obj: self),
            let themeName = self.theme
            else { return nil }
        
        return (className, themeName)
    }
    
    fileprivate func swizzled_updateTheme(_ themeDic: FTThemeDic?) {
        
        guard let theme = themeDic else { return }
        
        guard let themeSelf = self as? FTThemeProtocol else { return }
        
        for (kind, value) in theme {
            
            print("kind: \(kind), value: \(value)")
            
            switch kind {
                
            case "isLinkUnderlineEnabled":
                themeSelf.theme_isLinkUnderlineEnabled?(value as! Bool)
                
            case "isLinkDetectionEnabled":
                themeSelf.theme_isLinkDetectionEnabled?(value as! Bool)
                
            case "textfont":
                
                let fontName: String? = value as? String
                let font = FTThemesManager.getFont(fontName)
                
                if let font = font { themeSelf.theme_textfont?(font) }
                print(font!)
            
            case "textcolor":
                let colorName: String? = value as? String
                let color = FTThemesManager.getColor(colorName)
                
                if let color = color { themeSelf.theme_textcolor?(color) }
                print(color!)
                
            case "backgroundColor":
                let colorName: String? = value as? String
                let color = FTThemesManager.getColor(colorName)
                
                if let color = color { themeSelf.theme_backgroundColor?(color) }
                
            default:
                break
            }
        }
    
        themeSelf.updateTheme?(theme)
    }
}
