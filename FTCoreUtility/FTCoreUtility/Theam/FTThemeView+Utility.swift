//
//  FTThemeView+Utility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTThemeDic = [String : Any]

public struct ThemeStyle {
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

//Used for UIView subclasses Type
@objc public protocol FTThemeProtocol {
    
    //Retruns 'ThemeStyle' specific to current state of object.
    //Say if UIView is disabled, retrun "disabled", which can be clubed with main Theme style.
    //Eg, if currentTheme is 'viewB', then when disabled state, theme willbe : 'viewB:disabled'
    func get_ThemeSubType() -> String?
    
    //Custom Subclass can implement, to config Custom component
    @objc optional func updateTheme(_ theme: FTThemeDic)
    
    //Used for Label
    @objc optional func theme_isLinkUnderlineEnabled(_ bool: Bool)
    @objc optional func theme_isLinkDetectionEnabled(_ bool: Bool)
    @objc optional func theme_textfont(_ font: UIFont)
    @objc optional func theme_textcolor(_ color: UIColor)
    
    //Common for all UIView
    @objc optional func theme_backgroundColor(_ color: UIColor)
}

//Used for UIControl objects, when multiple states are possible to set at initalization
@objc public protocol FTUIControlThemeProtocol {
    
    @objc optional func get_AllThemeSubType() -> Bool
    @objc optional func setThemes(_ themes: FTThemeDic)
    @objc optional func update(themeDic: FTThemeDic, state: UIControlState)
}

//Propery variable to store theme's value.
public protocol FTUILabelThemeProperyProtocol {
    var theme_linkUndelineEnabled: Bool { get set }
    var theme_linkDetectionEnabled: Bool { get set }
}

extension UIView {
    
    //Theme style-name for the view
    @IBInspectable
    open var theme: String? {
        get { return UIView.aoThemes[self] }
        set {
            UIView.aoThemes[self] = newValue
            //Relaod view's theme, if styleName changes, when next time view layouts
            self.needsThemesUpdate = true
        }
    }
    
    //To tigger view-Theme styling
    open var needsThemesUpdate: Bool {
        get { return UIView.aoThemesNeedsUpdate[self] ?? false }
        set {
            UIView.aoThemesNeedsUpdate[self] = newValue
            if newValue {
                self.setNeedsLayout()
                self.generateVisualThemes()
            }
        }
    }
    
    open override func prepareForInterfaceBuilder() {
//        showErrorIfInvalidStyles()
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

fileprivate extension UIView {
    
    func generateVisualThemes() {
        
        //If Theme is emtpy, retrun
        guard !FTThemesManager.themesJSON.isEmpty else { return }
        
        //Get ThemeName and view's name to get Theme's property
        guard let (className, themeName) = self.get_ThemeName() else { return }
        
        //Checkout if view supports Theming protocal
        let delegate: FTThemeProtocol? = self as? FTThemeProtocol
        
        //Get Theme property of view based on its state
        guard let themeDic = FTThemesManager.generateVisualThemes(forClass: className,
                                                                  withStyleName: themeName,
                                                                  withSubStyleName: delegate?.get_ThemeSubType())
            else { return }
        
        //Config view with new Theme-style
        self.swizzled_updateTheme(themeDic)
        
        //Only needed for UIControl types, Eg. Button
        guard let controlThemeSelf = self as? FTUIControlThemeProtocol else { return }

        //Get styles for diffrent states of UIControl
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
    
    //Retruns ('classname', 'Theme-style-name') only if both are valid
    func get_ThemeName() -> (String, String)? {
        guard
            let className = get_classNameAsString(obj: self),
            let themeName = self.theme
            else { return nil }
        
        return (className, themeName)
    }
    
    //Update view with styleValues
    func swizzled_updateTheme(_ themeDic: FTThemeDic?) {
        
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
                
            //TODO: have work on borderStyle and othes
            //Will be done by generating a layer and add it as subView
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
        
        //Get all subTheme for all stats of the control
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

