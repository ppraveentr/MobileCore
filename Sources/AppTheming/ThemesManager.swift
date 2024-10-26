//
//  ThemesManager.swift
//  MobileCore-AppTheming
//
//  Created by Praveen Prabhakar on 29/07/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import Foundation
import UIKit

public typealias ThemeModel = [String: Any]

public enum ThemeType: String, CaseIterable {
    case color, font, layer, appearance, link, components
    
    public enum Key: String, CaseIterable {
        // Theme Super Components
        case defaultValue = "default", superComponent = "_super"
        // Image
        case clear, image, backgroundImage, backIndicatorImage, backIndicatorTransitionMaskImage, shadowImage
        // Appearanc
        case titleText, isTranslucent
        case tintColor, barTintColor, backgroundColor, foregroundColor
        case gradientLayer, colors, locations
        // Font
        case system, boldSystem, italicSystem
        // Label
        case font, name, size, weight, textfont, textcolor, underline, style
        case isLinkUnderlineEnabled, isLinkDetectionEnabled
        // Layer
        case masksToBounds, cornerRadius, borderWidth, borderColor
        case shadowPath, shadowOffset, shadowColor, shadowRadius, shadowOpacity
    }
}

public enum ThemeStyle: String, CaseIterable {
    case defaultStyle = "default"
    case highlightedStyle = "highlighted"
    case selectedStyle = "selected"
    case disabledStyle = "disabled"
    
    public static func allStyles() -> [ThemeStyle] {
        [ .highlightedStyle, .selectedStyle, .disabledStyle ]
    }
}

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
    public static func generateVisualThemes(_ name: String, styleName: String, subStyleName subStyle: ThemeStyle? = nil) -> ThemeModel? {
        var styleName = styleName
        // If any subTheme is avaiable, say when button is Highlighted, or view is disabled
        if let subStyle = subStyle, !styleName.contains(":") {
            styleName += ":" + subStyle.rawValue
        }
        // Get theme component
        guard let currentTheme: ThemeModel = ThemesManager.getViewComponent(name, styleName: styleName) else {
            // ftLog("Error: Theme of type \(styleName) not avaialble for class \(name)" )
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
    public static func getColor(_ colorName: String?) -> UIColor? {
        guard let colorName = colorName else { return nil }
        // Check if its image coded string
        if colorName.hasPrefix("@"), let image = ThemesManager.getImage(colorName) {
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
        if color == ThemeType.Key.clear.rawValue {
            return UIColor.clear
        }
        return nil
    }
    
    // MARK: UIFont
    public static func getFont(_ fontName: String?) -> UIFont? {
        let font: ThemeModel = ThemesManager.getDefaults(type: .font, keyName: fontName) as? ThemeModel ?? [:]
        if let name: String = font[ThemeType.Key.name] as? String,
           let sizeValue: String = font[ThemeType.Key.size] as? String,
           let size = NumberFormatter().number(from: sizeValue) {
            // Size Value
            let sizeValue = CGFloat(truncating: size)
            var weight: UIFont.Weight = .regular
            if let value = font[ThemeType.Key.weight] as? CGFloat {
               weight = UIFont.Weight(value)
            }
            switch name {
            case ThemeType.Key.system.rawValue:
                return UIFont.systemFont(ofSize: sizeValue, weight: weight)
            case ThemeType.Key.boldSystem.rawValue:
                return UIFont.boldSystemFont(ofSize: sizeValue)
            case ThemeType.Key.italicSystem.rawValue:
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
        if let value = theme[ThemeType.Key.foregroundColor] as? String {
            attributes[.foregroundColor] = self.getColor(value)
        }
        return attributes
    }
    
    // MARK: CAGradientLayer
    public static func getGradientLayer(_ layer: ThemeModel?) -> CAGradientLayer? {
        guard let layer = layer else { return nil }
        let gradient = CAGradientLayer()
        for (name, value) in layer {
            switch name {
            case ThemeType.Key.colors.rawValue:
                if let colors = value as? [String] {
                    gradient.colors = colors.compactMap { getColor($0)?.cgColor }
                }
            case ThemeType.Key.locations.rawValue:
                if let locations = value as? [Float] {
                    gradient.locations = locations.compactMap { NSNumber(value: $0) }
                }
            default:
                break
            }
        }
        return gradient
    }

    // MARK: CALayer
    public static func getLayer(_ layerName: String? = nil) -> ThemeModel? {
        ThemesManager.getDefaults(type: .layer, keyName: layerName) as? ThemeModel ?? [:]
    }
    
    // MARK: CGFloat value
    private static let floatValue = { (value: Any) -> CGFloat in
        if let i = value as? Float {
            return CGFloat(i)
        }
        return 0.0
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
        let caLayer = toLayer ?? CALayer()
        for (name, value) in layer {
            switch name {
            case ThemeType.Key.cornerRadius.rawValue:
                caLayer.cornerRadius = floatValue(value)
            case ThemeType.Key.borderWidth.rawValue:
                caLayer.borderWidth = floatValue(value)
            case ThemeType.Key.masksToBounds.rawValue:
                caLayer.masksToBounds = (value as? Bool) ?? false
            case ThemeType.Key.borderColor.rawValue:
                caLayer.borderColor = ThemesManager.getColor(value as? String)?.cgColor
            case ThemeType.Key.shadowOffset.rawValue:
                caLayer.shadowOffset = ThemesManager.getSize(value)
            case ThemeType.Key.shadowPath.rawValue:
                caLayer.shadowOffset = .zero
                let rect = CGRect(x: 0, y: 0, width: caLayer.bounds.width, height: caLayer.bounds.height)
                caLayer.shadowPath = UIBezierPath(rect: rect).cgPath
            case ThemeType.Key.shadowColor.rawValue:
                caLayer.shadowColor = ThemesManager.getColor(value as? String)?.cgColor
            case ThemeType.Key.shadowRadius.rawValue:
                caLayer.shadowRadius = floatValue(value)
            case ThemeType.Key.shadowOpacity.rawValue:
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

extension ThemeModel {
    subscript(key: ThemeType.Key) -> Any? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    
    subscript(theme: ThemeType) -> Any? {
        get { self[theme.rawValue] }
        set { self[theme.rawValue] = newValue }
    }
}

extension ThemesManager {
    static subscript(key: ThemeType) -> ThemeModel? {
        ThemesManager.themesJSON[key] as? ThemeModel
    }
    
    // MARK: Component
    fileprivate class var themeComponent: ThemeModel? { ThemesManager[ThemeType.components] }

    // Component - validity
    fileprivate static func isThemeComponentValid(_ component: String) -> Bool {
        // Get all the components of spefic type
        guard self.themeComponent?[component] is ThemeModel else { return false }
        return true
    }

    // Component -
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
    fileprivate class var themeColor: ThemeModel? { ThemesManager[ThemeType.color] }

    // Color -
    fileprivate static func themeColor(_ colorName: String) -> String? {
        self.themeColor?[colorName] as? String
    }

    // MARK: font
    fileprivate class var themeFont: ThemeModel? { ThemesManager[ThemeType.font] }

    // font -
    fileprivate static func themeFont(_ fontName: String) -> ThemeModel? {
        self.themeFont?[fontName] as? ThemeModel
    }

    // MARK: Appearance
    fileprivate class var themeAppearance: ThemeModel? { ThemesManager[ThemeType.appearance] }

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
    
    // MARK: Layer
    fileprivate class var themeLayer: ThemeModel? { ThemesManager[ThemeType.layer] }
    
    // layer -
    fileprivate static func themeLayer(_ layerName: String) -> ThemeModel? {
        self.themeLayer?[layerName] as? ThemeModel
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
            if dataVersion <= deviceVersion, let val = arg.value as? ThemeModel,
               baseModel == nil || (baseModel!.1 < dataVersion) {
                    baseModel = (val, dataVersion)
            }
        }
        
        if baseModel != nil {
            data += baseModel!.0
        }
        return data
    }
    
    // Defaults
    fileprivate static func getDefaults(type: ThemeType, keyName: String? = nil, styleName: String? = nil) -> Any? {
        guard let key = keyName else { return nil }
        var superBlock: ((String) -> Any?)?
        switch type {
        // Custome UIView Component
        case .components:
            let actualComponents = getThemeComponent(key, styleName: styleName)
            // TODO: iterative 'super' is still pending
            if
                let viewComponent = actualComponents,
                let superType = viewComponent[ThemeType.Key.superComponent] as? String,
                var superCom = getThemeComponent(key, styleName: superType) {
                // If view-component has super's style, use it as base component and merge its own style
                superCom += viewComponent
                superCom.removeValue(forKey: ThemeType.Key.superComponent.rawValue)
                
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
        let components: Any? = superBlock?(key) ?? superBlock?(ThemeStyle.defaultStyle.rawValue)
        // TODO: iterative 'super' is still pending
        if
            let currentComponent = components as? ThemeModel,
            let superType = currentComponent[ThemeType.Key.superComponent] as? String,
            let superComponents = superBlock?(superType) as? ThemeModel {
            
            // Merge super's style with current theme
            actualComponents = superComponents + currentComponent
        }
        return actualComponents ?? components
    }
}
