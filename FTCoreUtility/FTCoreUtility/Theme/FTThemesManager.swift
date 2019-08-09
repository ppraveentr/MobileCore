//
//  FTThemesManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class FTThemesManager {

    static var imageSourceBundle: [Bundle] = []
    
    // Theme JSON file loaded from Main-App
    static var themesJSON: FTThemeModel = [:] {
        willSet {
            if themesJSON.isEmpty && !newValue.isEmpty {
                // Inital view config
                 UIView.__setupThemes__()
            }
        }
        didSet {
            // Setup App config
            FTAppearanceManager.__setupThemes__()
        }
    }

    // 
    public static func addImageSourceBundle(imageSource: Bundle? = nil, imageSources: [Bundle]? = nil) {
        // Usefull for loading Images that are stored in bundle which are defined in Themes's JSON
        if let imageSource = imageSource {
            imageSourceBundle.append(imageSource)
        }

        if let imageSources = imageSources {
            imageSourceBundle.append(contentsOf: imageSources)
        }

        // FTReflection.registerModuleIdentifier(imageSource)

    }

    // 
    public static func setupThemes(themes: FTThemeModel, imageSourceBundle imageSource: [Bundle]? = nil) {
        
        // Usefull for loading Images that are stored in bundle which are defined in Themes's JSON
       self.addImageSourceBundle(imageSource: nil, imageSources: imageSource)

        // Update theme with new config
        // NOTE: currently does not spport merging of two theme files
        FTThemesManager.themesJSON = themes
    }
    
    // MARK: Theme components
    public static func generateVisualThemes(forClass name: String, withStyleName styleName: String, withSubStyleName subStyle: String? = nil) -> FTThemeModel? {
        
        var styleName = styleName
        
        // If any subTheme is avaiable, say when button is Highlighted, or view is disabled
        if let subStyle = subStyle, !styleName.contains(":") {
            styleName = styleName + ":" + subStyle
        }
        
        // Get theme component
        guard let currentTheme: FTThemeModel = FTThemesManager.getViewComponent(name, styleName: styleName) else {
            //FTLog("FTError: Theme of type \(styleName) not avaialble for class \(name)" )
            return nil
        }
        
        return currentTheme
    }
    
    // MARK: ViewComponents
    public static func isViewComponentValid(componentName: String) -> Bool {
        return self.isThemeComponentValid(componentName)
    }
    
    // TODO: custom themes for view-objects
    public static func getViewComponent(_ componentName: String, styleName: String?) -> FTThemeModel? {
        guard styleName != nil else {
            return nil
        }
        return FTThemesManager.getDefaults(type: .Component, keyName: componentName, styleName: styleName) as? FTThemeModel
    }
    
    // MARK: UIColor
    // TODO: gradian, rgb, alpha, ...
    public static func getColor(_ colorName: String?) -> UIColor? {

        // Check if its image coded string
        if
            (colorName?.hasPrefix("@"))!,
            let image = FTThemesManager.getImage(colorName) {
            return image.getColor()
        }

        // Get hex color
        if let hexColor = UIColor.hexColor(colorName ?? "") {
            return hexColor
        }

        // Color coded to hex-string
        let color: String = FTThemesManager.getDefaults(type: .Color, keyName: colorName) as? String ?? ""
        
        if let hexColor = UIColor.hexColor(color) {
            return hexColor
        }
        
        if color == "clear" {
            return UIColor.clear
        }
        
        return UIColor.black
    }
    
    // MARK: UIFont
    // TODO: bold, thin, ...
    public static func getFont(_ fontName: String?) -> UIFont? {
        
        let font: FTThemeModel = FTThemesManager.getDefaults(type: .Font, keyName: fontName) as? FTThemeModel ?? [:]
        
        if
            let name: String = font["name"] as? String,
            let sizeValue: String = font["size"] as? String,
            let size = NumberFormatter().number(from: sizeValue) {

            let sizeValue = CGFloat(truncating: size)

            switch name {

            case "system":
                return UIFont.systemFont(ofSize: sizeValue)

            case "boldSystem":
                return UIFont.boldSystemFont(ofSize: sizeValue)

            case "italicSystem":
                return UIFont.italicSystemFont(ofSize: sizeValue)

            default:
                return UIFont(name: name, size: sizeValue)
            }

        }
        
        return UIFont.systemFont(ofSize: 14.0)
    }
    
    // MARK: UIImage
    public static func getImage(_ imageName: Any?) -> UIImage? {
        
        guard let imageName = imageName else {
            return nil
        }

        if var imageName = imageName as? String {
            
            if imageName == "@empty" {
                return UIImage()
            }
            
            if imageName.hasPrefix("@") {
                // Search for image in all available bundles
                for bundleName in FTThemesManager.imageSourceBundle {
                    if let image = UIImage.init(named: imageName.trimPrefix("@"), in: bundleName, compatibleWith: nil) {
                        return image
                    }
                }
            }
        }
        
        return nil
    }

    // MARK: UIImage
    public static func getTextAttributes(_ theme: FTThemeModel?) -> [NSAttributedString.Key:AnyObject]? {

        guard let theme = theme else {
            return nil
        }

        var attributes = [NSAttributedString.Key:AnyObject]()
        if let value = theme["foregroundColor"] as? String {
            attributes[.foregroundColor] = self.getColor(value)
        }

        return attributes
    }

    // MARK: CALayer
    @discardableResult
    public static func getBackgroundLayer(_ layer: FTThemeModel?, toLayer: CALayer? = nil) -> CALayer? {

        guard let layer = layer else {
            return nil
        }

        let floatValue = { (value: Any) -> CGFloat in
            if let i = value as? Float {
                return CGFloat(i)
            }
            return 0.0
        }
        
        let caLayer = toLayer ?? CALayer()

        for (name, value) in layer {
            switch name {
            case "cornerRadius":
                caLayer.cornerRadius = floatValue(value)
                break
            case "borderWidth":
                caLayer.borderWidth = floatValue(value)
                break
            case "masksToBounds":
                caLayer.masksToBounds = floatValue(value) > 0
                break
            case "borderColor":
                let value = value as? String
                    caLayer.borderColor = FTThemesManager.getColor(value)?.cgColor
                break
            default:
                break
            }
        }

        return caLayer
    }
    
    // MARK: App Appearance
    // TODO: custom themes for view-objects
    public static func getAppearance(_ appearanceName: String? = nil) -> Any? {
        return themeAppearance(appearanceName)
    }
    
}

extension FTThemesManager {
    
    enum FTThemesType {
        case Component
        case Color
        case Font
    }
    
    // MARK: Component
    fileprivate class var themeComponent: FTThemeModel? {
        return FTThemesManager.themesJSON["components"] as? FTThemeModel
    }

    fileprivate static func isThemeComponentValid(_ component: String) -> Bool {
        // Get all the components of spefic type
        guard self.themeComponent?[component] as? FTThemeModel != nil else {
            return false
        }
        
        return true
    }

    fileprivate static func getThemeComponent(_ component: String, styleName: String? = nil) -> FTThemeModel? {
        
        // TODO: Merge all sub-styles into single JSON, for easy parsing.
        
        // Get all the components of spefic type
        guard let baseComponent = self.themeComponent?[component] as? FTThemeModel else {
            return nil
        }
        
        // Get pirticular style
        if styleName != nil {
            return baseComponent[styleName!] as? FTThemeModel
        }
        
        return baseComponent
    }

    // MARK: Color
    fileprivate class var themeColor: FTThemeModel? { return FTThemesManager.themesJSON["color"] as? FTThemeModel }

    // Color -
    fileprivate static func themeColor(_ colorName: String) -> String? {
        return self.themeColor?[colorName] as? String
    }

    // MARK: Font
    fileprivate class var themeFont: FTThemeModel? {
        return FTThemesManager.themesJSON["font"] as? FTThemeModel
    }

    // Font -
    fileprivate static func themeFont(_ fontName: String) -> FTThemeModel? {
        return self.themeFont?[fontName] as? FTThemeModel
    }

    // MARK: Appearance
    fileprivate class var themeAppearance: FTThemeModel? {
        return FTThemesManager.themesJSON["appearance"] as? FTThemeModel
    }

    // Appearance -
    fileprivate static func themeAppearance(_ appearanceName: String? = nil) -> Any? {
        
        // If 'appearanceName' is missing retrun all themes
        guard let appearanceName = appearanceName else {
            return self.themeAppearance
        }
        
        // If requested for particular appearance
        if appearanceName.contains(":") {
            return themeAppearance?[appearanceName] as? FTThemeModel
        }

        // Retruns all appearance, which has same base name        
        return themeAppearance?.filter { $0.0.hasPrefix(appearanceName) }
    }
    
    // Defaults
    fileprivate static func getDefaults(type: FTThemesType, keyName: String? = nil, styleName: String? = nil) -> Any?  {
        
        guard let key = keyName else {
            return nil
        }
        
        var superBlock: ((String) -> Any?)?
        
        switch type {
            
        // Custome UIView Component
        case .Component:
            
            let actualComponents = getThemeComponent(key,styleName: styleName)
            
            // TODO: iterative 'super' is still pending
            if
                let viewComponent = actualComponents,
                let superType = viewComponent["_super"] as? String,
                var superCom = getThemeComponent(key,styleName: superType) {
                // If view-component has super's style, use it as base component and merge its own style
                superCom += viewComponent
                superCom.removeValue(forKey: "_super")
                
                // Merged result
                return superCom
            }

            return actualComponents
            
        // Convert JSON to UIColor
        case .Color:
            superBlock = { (colorName) in
                return themeColor(colorName)
            }
            break
            
            // Convert JSON to UIFont
        case .Font:
            superBlock = { (fontName) in
                return themeFont(fontName)
            }
            
            break
        }
        
        var actualComponents: Any? = nil

        // If component of specifc type is not found, search for "default" style
        let components: Any? = superBlock?(key) ?? superBlock?(FTThemeStyle.defaultStyle)

        // TODO: iterative 'super' is still pending
        if
            let currentComponent = components as? FTThemeModel,
            let superType = currentComponent["_super"] as? String,
            let superComponents = superBlock?(superType) as? FTThemeModel {
            
            // Merge super's style with current theme
            actualComponents = superComponents + currentComponent
        }
        
        return actualComponents ?? components
    }
    
}
