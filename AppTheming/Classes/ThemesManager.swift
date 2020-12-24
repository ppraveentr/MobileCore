//
//  ThemesManager.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

open class ThemesManager {

    static var imageSourceBundle: [Bundle] = []
    
    // Theme JSON file loaded from Main-App
    static var themesJSON: ThemeModel = [:] {
        willSet {
            if themesJSON.isEmpty && !newValue.isEmpty {
                // Inital view config
                 UIView.setupThemes()
            }
        }
        didSet {
            // Setup App config
            AppearanceManager.setupApplicationTheme()
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
    public static func setupThemes(themePath: String, imageSourceBundle imageSource: [Bundle]? = nil) {
        if let themeContent: ThemeModel = try? themePath.jsonContentAtPath() {
             ThemesManager.setupThemes(themes: themeContent, imageSourceBundle: imageSource)
        }
    }
    // 
    public static func setupThemes(themes: ThemeModel, imageSourceBundle imageSource: [Bundle]? = nil) {
        
        // Usefull for loading Images that are stored in bundle which are defined in Themes's JSON
       self.addImageSourceBundle(imageSource: nil, imageSources: imageSource)

        // Update theme with new config
        // NOTE: currently does not spport merging of two theme files
        ThemesManager.themesJSON = themes
    }
    
    // MARK: Theme components
    public static func generateVisualThemes(forClass name: String, styleName: String, subStyleName subStyle: String? = nil) -> ThemeModel? {
        
        var styleName = styleName
        
        // If any subTheme is avaiable, say when button is Highlighted, or view is disabled
        if let subStyle = subStyle, !styleName.contains(":") {
            styleName += ":" + subStyle
        }
        
        // Get theme component
        guard let currentTheme: ThemeModel = ThemesManager.getViewComponent(name, styleName: styleName) else {
            // ftLog("FTError: Theme of type \(styleName) not avaialble for class \(name)" )
            return nil
        }
        
        return currentTheme
    }
    
    // MARK: ViewComponents
    public static func isViewComponentValid(componentName: String) -> Bool {
        self.isThemeComponentValid(componentName)
    }
    
    // TODO: custom themes for view-objects
    public static func getViewComponent(_ componentName: String, styleName: String?) -> ThemeModel? {
        guard styleName != nil else {
            return nil
        }
        return ThemesManager.getDefaults(type: .component, keyName: componentName, styleName: styleName) as? ThemeModel
    }
    
    // MARK: UIColor
    // TODO: gradian, rgb, alpha, ...
    public static func getColor(_ colorName: String?) -> UIColor? {

        // Check if its image coded string
        if
            (colorName?.hasPrefix("@"))!,
            let image = ThemesManager.getImage(colorName) {
            return image.getColor()
        }

        // Get hex color
        if let hexColor = UIColor.hexColor(colorName ?? "") {
            return hexColor
        }

        // Color coded to hex-string
        let color: String = ThemesManager.getDefaults(type: .color, keyName: colorName) as? String ?? ""
        
        if let hexColor = UIColor.hexColor(color) {
            return hexColor
        }
        
        if color == "clear" {
            return UIColor.clear
        }
        
        return nil
    }
    
    // MARK: UIFont
    // TODO: bold, thin, ...
    public static func getFont(_ fontName: String?) -> UIFont? {
        
        let font: ThemeModel = ThemesManager.getDefaults(type: .font, keyName: fontName) as? ThemeModel ?? [:]
        
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

        if let imageName = imageName as? String {
            
            if imageName == "@empty" {
                return UIImage()
            }
            
            if imageName.hasPrefix("@") {
                // Search for image in all available bundles
                for bundleName in ThemesManager.imageSourceBundle {
                    if let image = UIImage(named: imageName.trimingPrefix("@"), in: bundleName, compatibleWith: nil) {
                        return image
                    }
                }
            }
        }
        
        return nil
    }

    // MARK: UIImage
    public static func getTextAttributes(_ theme: ThemeModel?) -> [NSAttributedString.Key: AnyObject]? {

        guard let theme = theme else {
            return nil
        }

        var attributes = [NSAttributedString.Key: AnyObject]()
        if let value = theme["foregroundColor"] as? String {
            attributes[.foregroundColor] = self.getColor(value)
        }

        return attributes
    }

    // MARK: CALayer
    @discardableResult
    public static func getBackgroundLayer(_ layer: ThemeModel?, toLayer: CALayer? = nil) -> CALayer? {

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
            case "borderWidth":
                caLayer.borderWidth = floatValue(value)
            case "masksToBounds":
                caLayer.masksToBounds = floatValue(value) > 0
            case "borderColor":
                let value = value as? String
                    caLayer.borderColor = ThemesManager.getColor(value)?.cgColor
            default:
                break
            }
        }

        return caLayer
    }
    
    // MARK: App Appearance
    // TODO: custom themes for view-objects
    public static func getAppearance(_ appearanceName: String? = nil) -> Any? {
        themeAppearance(appearanceName)
    }
}

extension ThemesManager {
    
    enum FTThemesType {
        case component
        case color
        case font
    }
    
    // MARK: Component
    fileprivate class var themeComponent: ThemeModel? {
        ThemesManager.themesJSON["components"] as? ThemeModel
    }

    fileprivate static func isThemeComponentValid(_ component: String) -> Bool {
        // Get all the components of spefic type
        guard self.themeComponent?[component] as? ThemeModel != nil else {
            return false
        }
        
        return true
    }

    fileprivate static func getThemeComponent(_ component: String, styleName: String? = nil) -> ThemeModel? {
        
        // TODO: Merge all sub-styles into single JSON, for easy parsing.
        
        // Get all the components of spefic type
        guard let baseComponent = self.themeComponent?[component] as? ThemeModel else {
            return nil
        }
        
        // Get pirticular style
        if styleName != nil {
            return baseComponent[styleName!] as? ThemeModel
        }
        
        return baseComponent
    }

    // MARK: Color
    fileprivate class var themeColor: ThemeModel? { ThemesManager.themesJSON["color"] as? ThemeModel }

    // Color -
    fileprivate static func themeColor(_ colorName: String) -> String? {
        self.themeColor?[colorName] as? String
    }

    // MARK: font
    fileprivate class var themeFont: ThemeModel? {
        ThemesManager.themesJSON["font"] as? ThemeModel
    }

    // font -
    fileprivate static func themeFont(_ fontName: String) -> ThemeModel? {
        self.themeFont?[fontName] as? ThemeModel
    }

    // MARK: Appearance
    fileprivate class var themeAppearance: ThemeModel? {
        ThemesManager.themesJSON["appearance"] as? ThemeModel
    }

    // Appearance -
    fileprivate static func themeAppearance(_ appearanceName: String? = nil) -> Any? {
        
        // If 'appearanceName' is missing retrun all themes
        guard let appearanceName = appearanceName else {
            return self.themeAppearance
        }
        
        // If requested for particular appearance
        if appearanceName.contains(":") {
            return themeAppearance?[appearanceName] as? ThemeModel
        }

        // Retruns all appearance, which has same base name        
        return themeAppearance?.filter { $0.0.hasPrefix(appearanceName) }
    }
    
    // Get updated ThemeModel based on device's Version
    /*
     "UISegmentedControl": {
        "default": {
            "tintColor": "white",
            "iOS12Style": true,
            "ios_13": {
                "tintColor": "navBarRed",
                "textcolor": "white"
            }
        }
     }
     */
    static func getOSVersion(model: ThemeModel) -> ThemeModel {
        
        let deviceVersion = BundleURLScheme.osVersion
        var data = model
        var baseModel: (ThemeModel, Float)?
        
        let osModels = model.filter { $0.key.hasPrefix("ios_") }
        osModels.forEach { arg in
            let key = arg.key.trimming("ios_")
            data.removeValue(forKey: arg.key)
            let dataVersion = NSString(string: key).floatValue
            if dataVersion <= deviceVersion, let val = arg.value as? ThemeModel {
                if baseModel == nil || (baseModel!.1 < dataVersion) {
                    baseModel = (val, dataVersion)
                }
            }
        }
        
        if baseModel != nil {
            data += baseModel!.0
        }
        
        return data
    }
    
    // Defaults
    fileprivate static func getDefaults(type: FTThemesType, keyName: String? = nil, styleName: String? = nil) -> Any? {
        
        guard let key = keyName else {
            return nil
        }
        
        var superBlock: ((String) -> Any?)?
        
        switch type {
            
        // Custome UIView Component
        case .component:
            
            let actualComponents = getThemeComponent(key, styleName: styleName)
            
            // TODO: iterative 'super' is still pending
            if
                let viewComponent = actualComponents,
                let superType = viewComponent["_super"] as? String,
                var superCom = getThemeComponent(key, styleName: superType) {
                // If view-component has super's style, use it as base component and merge its own style
                superCom += viewComponent
                superCom.removeValue(forKey: "_super")
                
                // Merged result
                return getOSVersion(model: superCom)
            }
            
            if let viewComponent = actualComponents {
                return getOSVersion(model: viewComponent)
            }
            
            return actualComponents
            
        // Convert JSON to UIColor
        case .color:
            superBlock = { themeColor($0) }
            
            // Convert JSON to UIFont
        case .font:
            superBlock = { themeFont($0) }
        }
        
        var actualComponents: Any?

        // If component of specifc type is not found, search for "default" style
        let components: Any? = superBlock?(key) ?? superBlock?(ThemeStyle.defaultStyle)

        // TODO: iterative 'super' is still pending
        if
            let currentComponent = components as? ThemeModel,
            let superType = currentComponent["_super"] as? String,
            let superComponents = superBlock?(superType) as? ThemeModel {
            
            // Merge super's style with current theme
            actualComponents = superComponents + currentComponent
        }
        
        return actualComponents ?? components
    }
}
