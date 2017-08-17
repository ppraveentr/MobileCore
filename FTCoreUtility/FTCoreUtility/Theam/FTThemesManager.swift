//
//  FTThemesManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTThemeDic = [String : Any]

@objc public protocol FTThemeProtocol {
    func get_ThemeSubType() -> String?
    @objc optional func updateTheme(_ theme: FTThemeDic)
    
    @objc optional func theme_isLinkUnderlineEnabled(_ bool: Bool)
    @objc optional func theme_isLinkDetectionEnabled(_ bool: Bool)
    
    @objc optional func theme_textfont(_ font: UIFont)
    
    @objc optional func theme_textcolor(_ color: UIColor)
    
    @objc optional func theme_backgroundColor(_ color: UIColor)
}

public protocol FTUILabelThemeProtocol {
    var theme_linkUndelineEnabled: Bool { get set }
    var theme_linkDetectionEnabled: Bool { get set }
}

open class FTThemesManager {

    static var themesJSON: FTThemeDic = [:]
    
    public class func setupThemes(themes: FTThemeDic) {
        FTThemesManager.themesJSON = themes
        UIView.__setupThemes__()
    }
    
    //MARK: Theme components
    public class func generateVisualThemes(forClass name: String, withStyleName styleName: String, withSubStyleName subStyle: String? = nil) -> FTThemeDic? {
        
        guard let currentTheme: FTThemeDic = FTThemesManager.getViewComponent(name, styleName: styleName)
            else { //print("Theme of type \(styleName) not avaialble for class \(name)" )
                return nil }
        
        return currentTheme
    }
    
    //MARK: ViewComponents
    //TODO: custom themes for view
    open class func getViewComponent(_ componentName: String, styleName: String?) -> FTThemeDic? {
        guard (styleName != nil) else { return nil }
        return FTThemesManager.getDefaults(type: .Component, keyName: componentName, styleName: styleName) as? FTThemeDic
    }
    
    //MARK: UIColor
    //TODO: gradian, rgb, alpha, ...
    open class func getColor(_ colorName: String?) -> UIColor? {
        
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
    open class func getFont(_ fontName: String?) -> UIFont? {
        
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
    fileprivate class func getThemeFont(_ fontName: String) -> FTThemeDic? {
        return self.themeFont?[fontName] as? FTThemeDic
    }

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
