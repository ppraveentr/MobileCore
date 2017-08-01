//
//  FTThemesManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTThemeDic = [String : Any]

public protocol FTThemeProtocol {
    func updateVisualThemes()
}

open class FTTheme {
    
    public var name: String?

    public var font: UIFont?
    public var textColor: UIColor?
    
    public var backgroundColor: UIColor?
    
    public var isUnderLineEnabled: Bool = false
    
    open class func generateTheme(_ themeDic: FTThemeDic, name: String) -> FTTheme {
        //TODO
        let theme = FTTheme()
        theme.name = name
        
        if let fontName: String = themeDic.keyPath("text.font") {
            theme.font = FTThemesManager.getFont(fontName)
        }
        
        if let textColor: String = themeDic.keyPath("text.color") {
            theme.textColor = FTThemesManager.getColor(textColor)
        }
        
        if let backgroundColor: String = themeDic.keyPath("backgroundColor") {
            theme.backgroundColor = FTThemesManager.getColor(backgroundColor)
        }
        
        if let underLine: Bool = themeDic.keyPath("underline") {
            theme.isUnderLineEnabled = underLine
        }
        
        return theme
    }
}

open class FTThemesManager {

    static var themesJSON: FTThemeDic = [:]
    
    public class func setupThemes(themes: FTThemeDic) {
        FTThemesManager.themesJSON = themes
        UIView.__setupThemes__()
    }
    
    //MARK: Theme components
    public class func generateVisualThemes(forClass name: String, withStyleName styleName: String) -> FTTheme? {
        
        guard let currentTheme: FTThemeDic = FTThemesManager.getViewComponent(name, styleName: styleName)
            else { print("Theme of type \(styleName) not avaialble for class \(name)" )
                return nil }
        
        return FTTheme.generateTheme(currentTheme, name: name+"."+styleName)
    }
    
    //MARK: ViewComponents
    //TODO: custom themes for view
    open class func getViewComponent(_ componentName: String, styleName: String?) -> FTThemeDic? {
        guard (styleName != nil) else { return nil }
        return FTThemesManager.getDefaults(type: .Component, keyName: componentName, styleName: styleName) as? FTThemeDic
    }
    
    //MARK: UIColor
    //TODO: gradian, rgb, alpha, ...
    open class func getColor(_ colorName: String) -> UIColor? {
        
        let color: String = FTThemesManager.getDefaults(type: .Color, keyName: colorName) as? String ?? ""
        
        if color == "clear" {
            return UIColor.clear
        }
        
        if
            color.hasPrefix("#"),
            let hexColor = UIColor.hexColor(color) {
            return hexColor
        }
        
        return UIColor.black
    }
    
    //MARK: UIFont
    //TODO: bold, thin, ...
    open class func getFont(_ fontName: String) -> UIFont? {
        
        var font: FTThemeDic = self.getDefaults(type: .Font, keyName: fontName) as? FTThemeDic ?? [:]
        
        if
            let name: String = font["name"] as? String,
            let sizeValue: String = font["size"] as? String,
            let size = NumberFormatter().number(from: sizeValue) {
            
            if name == "system" {
                return UIFont.systemFont(ofSize: CGFloat(size))
            }
            
            return UIFont(name: name, size: CGFloat(size))
        }
        
        return UIFont.systemFont(ofSize: 14.0)
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
    fileprivate static let aoGeneratedThemes = FTAssociatedObject<FTTheme>()
    
    fileprivate final func __updateVisualThemes__() {
        self.needsThemesUpdate = false
        
        if let updateVisualSelf = self as? FTThemeProtocol {
            updateVisualSelf.updateVisualThemes()
        }
    }
}

public extension UIView {
    
    @IBInspectable
    public final var theme: String? {
        get { return UIView.aoThemes[self] }
        set {
            UIView.aoThemes[self] = newValue
            self.generatedTheme = self.generateVisualThemes(theme: newValue)
            self.needsThemesUpdate = true
        }
    }
    
    public final var generatedTheme: FTTheme? {
        get { return UIView.aoGeneratedThemes[self] }
        set { UIView.aoGeneratedThemes[self] = newValue }
    }
    
    public final var needsThemesUpdate: Bool {
        get { return UIView.aoThemesNeedsUpdate[self] ?? false }
        set { UIView.aoThemesNeedsUpdate[self] = newValue }
    }
    
    fileprivate func generateVisualThemes(theme: String?) -> FTTheme? {
        
        guard
            let className = get_classNameAsString(obj: self),
            let themeName = self.theme
            else { return nil }
        
        return FTThemesManager.generateVisualThemes(forClass: className, withStyleName: themeName)
    }
}

extension FTThemesManager {
    
    enum FTThemesType {
        case Component
        case Color
        case Font
    }
    
    //MARK: Component
    fileprivate class var themeComponent: FTThemeDic? { return FTThemesManager.themesJSON["components"] as? FTThemeDic }
    fileprivate class func getThemeComponent(_ component: String, styleName: String? = nil) -> FTThemeDic? {
        
        guard let baseComponent = self.themeComponent?[component] as? FTThemeDic else { return nil }
        
        if styleName != nil {
            return baseComponent[styleName!] as? FTThemeDic
        }
        
        return baseComponent
    }

    //Color
    fileprivate class var themeColor: FTThemeDic? { return FTThemesManager.themesJSON["color"] as? FTThemeDic }
    fileprivate class func getThemeColor(_ colorName: String) -> String? { return self.themeColor?[colorName] as? String }

    //Font
    fileprivate class var themeFont: FTThemeDic? { return FTThemesManager.themesJSON["font"] as? FTThemeDic }
    fileprivate class func getThemeFont(_ fontName: String) -> FTThemeDic? { return self.themeFont?[fontName] as? FTThemeDic }

    //Defaults
    fileprivate class func getDefaults(type: FTThemesType, keyName: String?, styleName: String? = nil) -> Any?  {
        
        guard let key = keyName else { return nil }
        
        var superBlock: ((String) -> Any?)?
        
        switch type {
            
        case .Component:
            
            let actualComponents = getThemeComponent(key,styleName: styleName)
            
            if
                let viewComponent = actualComponents,
                let superType = viewComponent["_super"] as? String,
                var superCom = getThemeComponent(key,styleName: superType) {
                
                superCom += viewComponent
                superCom.removeValue(forKey: "_super")
                
                return superCom
            }

            return actualComponents
            
        case .Color:
            superBlock = { (colorName) in
                return getThemeColor(colorName)
            }
            break
            
        case .Font:
            superBlock = { (fontName) in
                return getThemeFont(fontName)
            }
            
            break
        }
        
        var actualComponents: Any? = nil

        let components: Any? = superBlock?(key) ?? superBlock?("default")

        if
            let currentComponent = components as? FTThemeDic,
            let superType = currentComponent["_super"] as? String,
            let superComponents = superBlock?(superType) as? FTThemeDic {
            
            actualComponents = superComponents + currentComponent
        }
        
        return actualComponents ?? components
    }
}
