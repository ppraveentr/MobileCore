//
//  FTThemesManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

typealias ThemeDic = [String : Any]

@objc public protocol FTThemeProtocol {
    func updateVisualThemes()
}

public struct FTTheme {
    
    public var name: String?

    public var font: UIFont?
    public var textColor: UIColor?
    
    public var backgroundColor: UIColor?
    
    public var isUnderLineEnabled: Bool = false
}

open class FTThemesManager {

    static var themesJSON: ThemeDic = [:]
    
    public class func setupThemes(themes: [String : Any]) {
        FTThemesManager.themesJSON = themes
        UIView.__setupThemes__()
    }
    
    public class func get_themeComponent(name: String, styleName: String) -> FTTheme? {
        
        guard let currentTheme: ThemeDic = FTThemesManager.getComponent(name, styleName: styleName)
            else { print("Theme of type \(styleName) not avaialble for class \(name)" )
                return nil }
        
        return self.generageTheme(currentTheme, name: name+"."+styleName)
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
        
        if self.responds(to: #selector(FTThemeProtocol.updateVisualThemes)) {
            (self as AnyObject).updateVisualThemes?()
        }
    }
}

public extension UIView {
    
    @IBInspectable
    public final var theme: String? {
        get { return UIView.aoThemes[self] }
        set {
            UIView.aoThemes[self] = newValue
            self.generateTheme = self.generateVisualThemes(theme: newValue)
            self.needsThemesUpdate = true
        }
    }
    
    public final var generateTheme: FTTheme? {
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
        
        return FTThemesManager.get_themeComponent(name: className, styleName: themeName)
    }
    
//    public func updateVisualThemes() {
//        print(self.generateTheme ?? "")
//    }
}

extension Dictionary {
     
}

extension FTThemesManager {
    
    enum FTThemesType {
        case Component
        case Color
        case Font
    }
    
    fileprivate class func generageTheme(_ themeDic: [String : Any], name: String) -> FTTheme? {
        
        var theme = FTTheme()
        theme.name = name
        
        if let fontName: String = (themeDic as NSDictionary).value(forKeyPath: "text.font") as? String {
            theme.font = self.getFont(fontName)
        }
        
        if let textColor: String = (themeDic as NSDictionary).value(forKeyPath: "text.color") as? String {
            theme.textColor = self.getColor(textColor)
        }
        
        return theme
    }
    
    //MARK: Component
    fileprivate class var themeComponent: ThemeDic? { return FTThemesManager.themesJSON["components"] as? ThemeDic }
    fileprivate class func getThemeComponent(_ styleName: String) -> ThemeDic? { return self.themeComponent?[styleName] as? ThemeDic }

    //Color
    fileprivate class var themeColor: ThemeDic? { return FTThemesManager.themesJSON["color"] as? ThemeDic }
    fileprivate class func getThemeColor(_ colorName: String) -> String? { return self.themeColor?[colorName] as? String }

    //Font
    fileprivate class var themeFont: ThemeDic? { return FTThemesManager.themesJSON["font"] as? ThemeDic }
    fileprivate class func getThemeFont(_ fontName: String) -> ThemeDic? { return self.themeFont?[fontName] as? ThemeDic }

    //Defaults
    fileprivate class func getDefaults(type: FTThemesType, keyName: String?) -> Any?  {
        
        guard let key = keyName else { return nil }
        
        var superBlock: ((String) -> Any?)?
        
        switch type {
            
        case .Component:
            superBlock = { (componentName) in
                return getThemeComponent(componentName)
            }
            break
            
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
        
        let components: Any? = superBlock?(key) ?? superBlock?("default")
        var actualComponents: Any? = nil

        if
            let currentComponent = components as? ThemeDic,
            let superType = currentComponent["_super"] as? String,
            let superComponents = superBlock?(superType) as? ThemeDic {
            
            actualComponents = superComponents + currentComponent
        }
        
        return actualComponents ?? components
    }
    
    //MARK: components
    class func getComponent(_ componentName: String, styleName: String?) -> ThemeDic? {

        guard (styleName != nil) else { return [:] }

        let component: ThemeDic = self.getDefaults(type: .Component, keyName: componentName) as? ThemeDic ?? [:]
        return component[styleName!] as? ThemeDic
    }
    
    //MARK: UIColor
    class func getColor(_ colorName: String) -> UIColor? {
        
        let color: String = self.getDefaults(type: .Color, keyName: colorName) as? String ?? ""
        
        if color.hasPrefix("#") {
            return UIColor.hexColor(color)
        }

        //TODO: gradian, rgb
        
        return UIColor.black
    }
    
    //MARK: UIFont
    class func getFont(_ fontName: String) -> UIFont? {
        
        var font: ThemeDic = self.getDefaults(type: .Font, keyName: fontName) as? ThemeDic ?? [:]
        
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
