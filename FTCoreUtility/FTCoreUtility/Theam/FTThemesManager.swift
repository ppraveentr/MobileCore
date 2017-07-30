//
//  FTThemesManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

typealias ThemeDic = [String : Any]

open class FTThemesManager {

    static var themesJSON: ThemeDic = [:]
    
    public class func setupThemes(themes: [String : Any]) {
        FTThemesManager.themesJSON = themes
        UIView.__setupThemes__()
    }
}

extension FTThemesManager {
    
    //MARK: Component
    fileprivate class var themeComponent: ThemeDic? { return FTThemesManager.themesJSON["components"] as? ThemeDic }
    fileprivate class func getComponent(styleName: String) -> ThemeDic? { return self.themeComponent?[styleName] as? ThemeDic }

    //Color
    fileprivate class var themeColor: ThemeDic? { return FTThemesManager.themesJSON["color"] as? ThemeDic }
    fileprivate class func getComponent(colorName: String) -> ThemeDic? { return self.themeColor?[colorName] as? ThemeDic }

    //Font
    fileprivate class var themeFont: ThemeDic? { return FTThemesManager.themesJSON["font"] as? ThemeDic }
    fileprivate class func getComponent(fontName: String) -> ThemeDic? { return self.themeFont?[fontName] as? ThemeDic }

    //Defaults
//    fileprivate class func getDefaults(type: String?, keyName: String?) -> ThemeDic  {
//        
//        guard let componentType = type, let key = keyName else { return [:] }
//        
//        var actualComponents: ThemeDic = [ : ]
//
//        var defautDic: ThemeDic = [:]
//        var superDic: ((String) -> ThemeDic?)?
//        
//        switch componentType {
//        
//        case "font":
//            defautDic = self.themeFont ?? [:]
//            superDic = { (fontName) in
//                return getComponent(fontName: fontName)
//            }
//            
//        break
//            
//        case "color":
//            defautDic = self.themeColor ?? [:]
//            superDic = { (colorName) in
//                return getComponent(colorName: colorName)
//            }
//            break
//            
//        default: break
//            
//        }
//        
//        let fontComponent: ThemeDic = defautDic[key] as? ThemeDic
//            ?? defautDic["default"] as? ThemeDic
//            ?? [ : ]
//        
//        if
//            let superType = fontComponent["_super"] as? String,
//            let superComponents: ThemeDic = superDic?(superType) {
//            actualComponents += superComponents
//        }
//        
//        actualComponents += fontComponent
//        
//        return actualComponents
//    }
    
    fileprivate class func getDefaults<T>(type: String?, keyName: String?, block:( (_: Any?, _: Any?) -> T? ) ) -> T?  {
        
        guard let componentType = type, let key = keyName else { return nil }
        
        var defautDic: ThemeDic = [:]
        var superBlock: ((String) -> T?)?
        
        switch componentType {
            
        case "font":
            defautDic = self.themeFont ?? [:]
            superBlock = { (fontName) in
                return getComponent(fontName: fontName) as? T
            }
            
            break
            
        case "color":
            defautDic = self.themeColor ?? [:]
            superBlock = { (colorName) in
                return getComponent(colorName: colorName) as? T
            }
            break
            
        default: break
            
        }
        
        let components: Any? = defautDic[key] as? T ?? defautDic["default"] as? ThemeDic
        
        var actualComponents: T? = nil

        if
            let currentComponent = components as? ThemeDic,
            let superType = currentComponent["_super"] as? String,
            let superComponents = superBlock?(superType) {
            actualComponents = superComponents
        }
        
        return block(actualComponents ?? components, components)
    }
    
    
    //MARK: UIColor
    class func getColor(_ colorName: String) -> UIColor? {
        
        let color: String = self.getDefaults(type: "color", keyName: colorName) { (lhs, rhs) in
            return lhs as? String
        } ?? ""
        
        if color.hasPrefix("#") {
            return UIColor.hexColor(color)
        }

        
        return UIColor.black
    }
    
    //MARK: UIFont
    class func getFont(_ fontName: String) -> UIFont? {
        
        var font: ThemeDic = self.getDefaults(type: "font", keyName: fontName) { (lhs, rhs) in
            
            var actualComponents: ThemeDic = lhs as? ThemeDic ?? [:]
            let fontComponent: ThemeDic = rhs as? ThemeDic ?? [:]
            
            actualComponents += fontComponent
            
            return actualComponents
            
            } ?? [:]
        
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

    fileprivate final func __updateVisualThemes__() {
        self.needsThemesUpdate = false
        self.updateVisualThemes()
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
        set { UIView.aoThemesNeedsUpdate[self] = newValue }
    }
    
    func updateVisualThemes() { }
}
