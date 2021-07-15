//
//  AppearanceManager.swift
//  MobileCoreUtility
//
//  Created by Praveen Prabhakar on 30/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
// TODO: In progress
protocol AppearanceManagerProtocol {
    @discardableResult
    func setUpAppearance(theme: ThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance
}

public enum AppearanceManager {
    static func getComponentName(_ appearanceName: String) -> (String, String?) {
        let components = appearanceName.components(separatedBy: ":")
        if components.count > 1 {
            return (components.first!, components.last)
        }
        return (appearanceName, nil)
    }

    static func setupApplicationTheme() {
        guard let app = ThemesManager.getAppearance() as? ThemeModel else { return }
        for theme in app where ((theme.value as? ThemeModel) != nil) {
            if let themeObj: ThemeModel = theme.value as? ThemeModel {
                let components = getComponentName(theme.key)
                // Setup 'appearance' from Theme
                if let classTy: AppearanceManagerProtocol = Reflection.swiftClassFromString(components.0) as? AppearanceManagerProtocol {
                    var appearanceContainer: [UIAppearanceContainer.Type]?
                    if let className = components.1,
                        let objecClass = Reflection.swiftClassTypeFromString(className) {
                        appearanceContainer = [objecClass] as? [UIAppearanceContainer.Type]
                    }
                    classTy.setUpAppearance(theme: themeObj, containerClass: appearanceContainer)
                }
            }
        }
    }
}

extension UIView: AppearanceManagerProtocol {
    public func setUpAppearance(theme: ThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {
        type(of: self).setUpAppearance(theme: theme, containerClass: containerClass)
    }

    @discardableResult
    @objc public class func setUpAppearance(theme: ThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {
        let appearance = (containerClass == nil) ?  self.appearance() : self.appearance(whenContainedInInstancesOf: containerClass!)
        if let tintColor = theme[ThemeKey.tintColor.rawValue] {
            appearance.tintColor = ThemesManager.getColor(tintColor as? String)
        }
        if let backgroundImage = theme[ThemeKey.backgroundImage] {
            self.setBackgroundImage(backgroundImage)
        }
        return appearance
    }
    
    @objc public class func setBackgroundImage(_ imageTheme: Any) {
        self.setBackgroundImage(imageType: ThemeStyle.defaultStyle, imageName: imageTheme)
    }
    
    public class func setBackgroundImage(imageType: String?, imageName: Any) {
        if let types = imageName as? ThemeModel {
            types.forEach { setBackgroundImage(imageType: $0, imageName: $1) }
        }
        
        guard let imageType = imageType else { return }
        if let image = ThemesManager.getImage(imageName as? String),
           let segmentSelf = self as? UISegmentedControl.Type {
            segmentSelf.setBackgroundImage(imageType: imageType, image: image)
        }
    }
}

extension UISegmentedControl {
    override public class func setUpAppearance(theme: ThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {
        super.setUpAppearance(theme: theme, containerClass: containerClass)
//        let appearance = (containerClass == nil) ?  self.appearance() : self.appearance(whenContainedInInstancesOf: containerClass!)
//        return appearance
    }
    
    public class func setBackgroundImage(imageType: String, image: UIImage) {
        let image = image.withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let appearance = UISegmentedControl.appearance()
        if imageType == ThemeStyle.selectedStyle {
            appearance.setBackgroundImage(image, for: .selected, barMetrics: .default)
        }
        else {
            appearance.setBackgroundImage(image, for: UIControl.State(), barMetrics: .default)
        }
    }
}

extension UINavigationBar {
    // swiftlint:disable cyclomatic_complexity
    override public class func setUpAppearance(theme: ThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {
        super.setUpAppearance(theme: theme, containerClass: containerClass)
        let appearance = (containerClass == nil) ?  self.appearance() : self.appearance(whenContainedInInstancesOf: containerClass!)
       
        for type in ThemeKey.allCases {
            guard let value = theme[type.rawValue] else { continue }
            switch type {
            case .tintColor:
                appearance.tintColor = ThemesManager.getColor(value as? String)
            case .backIndicatorImage:
                appearance.backIndicatorImage = ThemesManager.getImage(value)
            case .backIndicatorTransitionMaskImage:
                appearance.backIndicatorTransitionMaskImage = ThemesManager.getImage(value)
            case .shadowImage:
                appearance.shadowImage = ThemesManager.getImage(value)
            case .isTranslucent:
                if let value = value as? Bool {
                    appearance.isTranslucent = value
                    // FIXIT: Not able to update statusbar color if not set to `blackTranslucent`
                    if value {
                        appearance.barStyle = .blackTranslucent
                    }
                }
            case .titleText:
                if let attributes = ThemesManager.getTextAttributes(value as? ThemeModel) {
                    appearance.titleTextAttributes = attributes
                    if #available(iOS 13.0, *) {
                        appearance.largeTitleTextAttributes = attributes
                    }
                }
            default:
                break
            }
        }

        if #available(iOS 13.0, *) {
            let navAppe = navBarAppearance(theme: theme, tile: appearance.titleTextAttributes, largeTitle: appearance.largeTitleTextAttributes)
            appearance.standardAppearance = navAppe
            appearance.compactAppearance = navAppe
            appearance.scrollEdgeAppearance = navAppe
        }
        return appearance
    }
    
    @available(iOS 13.0, *)
    private class func navBarAppearance(theme: ThemeModel, tile: AttributedDictionary?, largeTitle: AttributedDictionary?) -> UINavigationBarAppearance {
        let navAppe = UINavigationBarAppearance()
        if let imageTheme = theme[ThemeKey.backgroundImage] as? ThemeModel,
           let defaultImage = ThemesManager.getImage(imageTheme[ThemeKey.defaultValue]), let bgColor = defaultImage.getColor() {
            navAppe.backgroundColor = bgColor
        }
        if let attributes = tile {
            navAppe.titleTextAttributes = attributes
        }
        if let attributes = largeTitle {
            navAppe.largeTitleTextAttributes = attributes
        }
        return navAppe
    }
    // swiftlint:enable cyclomatic_complexity
    
    override public class func setBackgroundImage(_ image: Any) {
        // defaultImage
        var defaultImage: UIImage? = ThemesManager.getImage(image)
        var landScapeImage: UIImage?
        
        if let imageTheme = image as? ThemeModel {
            defaultImage = ThemesManager.getImage(imageTheme[ThemeKey.defaultValue])
            landScapeImage = ThemesManager.getImage(imageTheme["landScape"])
        }
        
        if defaultImage != nil {
            self.applyBackgroundImage(navigationBar: nil, defaultImage: defaultImage!, landScapeImage: landScapeImage)
        }
    }
}

extension UITabBar {
    override public class func setBackgroundImage(_ image: Any) {
        let appearance = self.appearance()
        if let defaultImage = ThemesManager.getImage(image) {
            appearance.backgroundImage = defaultImage
        }
    }
}
