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
        didSet { // Setup App config
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
        guard styleName != nil else { return nil }
        return ThemesManager.getDefaults(type: .components, keyName: componentName, styleName: styleName) as? ThemeModel
    }
    
    // MARK: UIColor
    // TODO: gradian, rgb, alpha, ...
    public static func getColor(_ colorName: String?) -> UIColor? {
        guard let colorName = colorName else { return nil }
        // Check if its image coded string
        if (colorName.hasPrefix("@")), let image = ThemesManager.getImage(colorName) {
            return image.getColor()
        }
        // Get hex color
        if let hexColor = UIColor.hexColor(colorName) {
            return hexColor
        }
        // Color coded to hex-string
        let color: String = ThemesManager.getDefaults(type: .color, keyName: colorName) as? String ?? ""
        if let hexColor = UIColor.hexColor(color) {
            return hexColor
        }
        if color == ThemeKey.clear.rawValue {
            return UIColor.clear
        }
        return nil
    }
    
    // MARK: UIFont
    // TODO: bold, thin, ...
    public static func getFont(_ fontName: String?) -> UIFont? {
        let font: ThemeModel = ThemesManager.getDefaults(type: .font, keyName: fontName) as? ThemeModel ?? [:]
        if let name: String = font[ThemeKey.name] as? String,
           let sizeValue: String = font[ThemeKey.size] as? String,
           let size = NumberFormatter().number(from: sizeValue) {
            // Size Value
            let sizeValue = CGFloat(truncating: size)
            var weight: UIFont.Weight = .regular
            if let value = font[ThemeKey.weight] as? CGFloat {
               weight = UIFont.Weight(value)
            }
            switch name {
            case ThemeKey.system.rawValue:
                return UIFont.systemFont(ofSize: sizeValue, weight: weight)
            case ThemeKey.boldSystem.rawValue:
                return UIFont.boldSystemFont(ofSize: sizeValue)
            case ThemeKey.italicSystem.rawValue:
                return UIFont.italicSystemFont(ofSize: sizeValue)
            default:
                return UIFont(name: name, size: sizeValue)
            }
        }
        return UIFont.systemFont(ofSize: 14.0)
    }
    
    // MARK: UIImage
    public static func getImage(_ imageName: Any?) -> UIImage? {
        guard let imageName = imageName as? String else { return nil }
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
        return nil
    }

    // MARK: UIImage
    public static func getTextAttributes(_ theme: ThemeModel?) -> AttributedDictionary? {
        guard let theme = theme else { return nil }
        var attributes = AttributedDictionary()
        if let value = theme[ThemeKey.foregroundColor] as? String {
            attributes[.foregroundColor] = self.getColor(value)
        }
        return attributes
    }

    // MARK: CALayer
    public static func getLayer(_ layerName: String? = nil) -> ThemeModel? {
        ThemesManager.getDefaults(type: .layer, keyName: layerName) as? ThemeModel ?? [:]
    }
    
    // MARK: Size
    public static func getSize(_ value: Any? = nil) -> CGSize {
        guard var value = value as? String else { return .zero }
        let comp = value.trimming(["{", "}", " "]).components(separatedBy: ",").map { size -> CGFloat in
            if let value = Float(size) {
                return CGFloat(value)
            }
            return 0
        }
        return CGSize(width: comp.first ?? 0, height: comp.last ?? 0)
    }
    
    @discardableResult
    public static func getBackgroundLayer(_ layer: ThemeModel?, toLayer: CALayer? = nil) -> CALayer? {
        guard let layer = layer else { return nil }

        let floatValue = { (value: Any) -> CGFloat in
            if let i = value as? Float {
                return CGFloat(i)
            }
            return 0.0
        }
        
        let caLayer = toLayer ?? CALayer()
        for (name, value) in layer {
            switch name {
            case ThemeKey.cornerRadius.rawValue:
                caLayer.cornerRadius = floatValue(value)
            case ThemeKey.borderWidth.rawValue:
                caLayer.borderWidth = floatValue(value)
            case ThemeKey.masksToBounds.rawValue:
                caLayer.masksToBounds = (value as? Bool) ?? false
            case ThemeKey.borderColor.rawValue:
                caLayer.borderColor = ThemesManager.getColor(value as? String)?.cgColor
            case ThemeKey.shadowOffset.rawValue:
                caLayer.shadowOffset = ThemesManager.getSize(value)
            case ThemeKey.shadowPath.rawValue:
                caLayer.shadowOffset = .zero
                let rect = CGRect(x: 0, y: 0, width: caLayer.bounds.width, height: caLayer.bounds.height)
                caLayer.shadowPath = UIBezierPath(rect: rect).cgPath
            case ThemeKey.shadowColor.rawValue:
                caLayer.shadowColor = ThemesManager.getColor(value as? String)?.cgColor
            case ThemeKey.shadowRadius.rawValue:
                caLayer.shadowRadius = floatValue(value)
            case ThemeKey.shadowOpacity.rawValue:
                if let value = value as? CGFloat {
                    caLayer.shadowOpacity = Float(value)
                }
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
    // MARK: Component
    fileprivate class var themeComponent: ThemeModel? {
        ThemesManager.themesJSON[ThemesType.components] as? ThemeModel
    }

    fileprivate static func isThemeComponentValid(_ component: String) -> Bool {
        // Get all the components of spefic type
        guard self.themeComponent?[component] as? ThemeModel != nil else { return false }
        return true
    }

    fileprivate static func getThemeComponent(_ component: String, styleName: String? = nil) -> ThemeModel? {
        // TODO: Merge all sub-styles into single JSON, for easy parsing.
        // Get all the components of spefic type
        guard let baseComponent = self.themeComponent?[component] as? ThemeModel else { return nil }
        // Get pirticular style
        if styleName != nil {
            return baseComponent[styleName!] as? ThemeModel
        }
        return baseComponent
    }

    // MARK: Color
    fileprivate class var themeColor: ThemeModel? { ThemesManager.themesJSON[ThemesType.color] as? ThemeModel }

    // Color -
    fileprivate static func themeColor(_ colorName: String) -> String? {
        self.themeColor?[colorName] as? String
    }

    // MARK: font
    fileprivate class var themeFont: ThemeModel? {
        ThemesManager.themesJSON[ThemesType.font] as? ThemeModel
    }

    // font -
    fileprivate static func themeFont(_ fontName: String) -> ThemeModel? {
        self.themeFont?[fontName] as? ThemeModel
    }

    // MARK: Appearance
    fileprivate class var themeAppearance: ThemeModel? {
        ThemesManager.themesJSON[ThemesType.appearance] as? ThemeModel
    }
    
    // MARK: Layer
    fileprivate class var themeLayer: ThemeModel? {
        ThemesManager.themesJSON[ThemesType.layer] as? ThemeModel
    }
    
    // layer -
    fileprivate static func themeLayer(_ layerName: String) -> ThemeModel? {
        self.themeLayer?[layerName] as? ThemeModel
    }

    // Appearance -
    fileprivate static func themeAppearance(_ appearanceName: String? = nil) -> Any? {
        // If 'appearanceName' is missing retrun all themes
        guard let appearanceName = appearanceName else { return themeAppearance }
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
    fileprivate static func getDefaults(type: ThemesType, keyName: String? = nil, styleName: String? = nil) -> Any? {
        guard let key = keyName else { return nil }
        var superBlock: ((String) -> Any?)?
        switch type {
        // Custome UIView Component
        case .components:
            let actualComponents = getThemeComponent(key, styleName: styleName)
            // TODO: iterative 'super' is still pending
            if
                let viewComponent = actualComponents,
                let superType = viewComponent[ThemeKey.superComponent] as? String,
                var superCom = getThemeComponent(key, styleName: superType) {
                // If view-component has super's style, use it as base component and merge its own style
                superCom += viewComponent
                superCom.removeValue(forKey: ThemeKey.superComponent.rawValue)
                
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
        case .layer:
            return themeLayer(key)
        case .appearance, .link:
            return nil
        }
        
        var actualComponents: Any?
        // If component of specifc type is not found, search for "default" style
        let components: Any? = superBlock?(key) ?? superBlock?(ThemeStyle.defaultStyle)
        // TODO: iterative 'super' is still pending
        if
            let currentComponent = components as? ThemeModel,
            let superType = currentComponent[ThemeKey.superComponent] as? String,
            let superComponents = superBlock?(superType) as? ThemeModel {
            
            // Merge super's style with current theme
            actualComponents = superComponents + currentComponent
        }
        return actualComponents ?? components
    }
}
