//
//  FTThemeView+Utility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

struct ThemeStyle {
    static let defaultStyle = "default"
    static let highlightedStyle = "highlighted"
    static let selectedStyle = "selected"
    static let disabledStyle = "disabled"
    
    static func allStyles() -> [String] {
        return [ThemeStyle.highlightedStyle,
                ThemeStyle.selectedStyle,
                ThemeStyle.disabledStyle]
    }
}


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
        
        //Only needed for UIControl types, Eg. Button
        guard let controlThemeSelf = self as? FTUIControlThemeProtocol else { return }

        if let subType = controlThemeSelf.get_AllThemeSubType?(), subType == true {
            
            let baseName = themeName.components(separatedBy: ":").first

            var styles: FTThemeDic = [:]

            ThemeStyle.allStyles().forEach({ (style) in
                
                if let styleThemeDic = FTThemesManager.generateVisualThemes(forClass: className,
                                                                       withStyleName: baseName!,
                                                                       withSubStyleName: style) {
                    
                    //Create FTThemeDic as, ['ThemeStyle.UIControlState' : 'ActualTheme for the state']
                    styles[style] = styleThemeDic
                }
            })
            
            controlThemeSelf.setThemes?(styles)
        }
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
            
            switch kind {
                
            case "isLinkUnderlineEnabled":
                themeSelf.theme_isLinkUnderlineEnabled?(value as! Bool)
                
            case "isLinkDetectionEnabled":
                themeSelf.theme_isLinkDetectionEnabled?(value as! Bool)
                
            case "textfont":
                
                let fontName: String? = value as? String
                let font = FTThemesManager.getFont(fontName)
                
                if let font = font { themeSelf.theme_textfont?(font) }
            
            case "textcolor":
                let colorName: String? = value as? String
                let color = FTThemesManager.getColor(colorName)
                
                if let color = color { themeSelf.theme_textcolor?(color) }
                
            case "backgroundColor":
                let colorName: String? = value as? String
                let color = FTThemesManager.getColor(colorName)
                
                if let color = color { themeSelf.theme_backgroundColor?(color) }
                
            default:
                break
            }
        }
    
        themeSelf.updateTheme?(theme)
        
        //Only needed for UIControl types, Eg. Button
        guard let controlThemeSelf = self as? FTUIControlThemeProtocol else { return }
        
        let themeDic = [themeSelf.get_ThemeSubType() ?? ThemeStyle.defaultStyle : theme]
        controlThemeSelf.setThemes?(themeDic)
    }
}

//Style for Different states for UIControl object
extension UIControl {
    
    public func get_AllThemeSubType() -> Bool { return true }

    public func setThemes(_ themes: FTThemeDic) {
        
        guard let themeSelf = self as? FTUIControlThemeProtocol else { return }

        for (kind, value) in themes {
            
            guard let theme = value as? FTThemeDic else { continue }
            
            switch kind {
                
            case ThemeStyle.defaultStyle:
                themeSelf.update?(themeDic: theme, state: .normal)
                break
                
            case ThemeStyle.disabledStyle:
                themeSelf.update?(themeDic: theme, state: .disabled)
                break
                
            case ThemeStyle.highlightedStyle:
                themeSelf.update?(themeDic: theme, state: .highlighted)
                break
                
            case ThemeStyle.selectedStyle:
                themeSelf.update?(themeDic: theme, state: .selected)
                break
                
            default:
                break
            }
        }
    }
}

