//
//  FTAppearanceManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 30/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
// TODO: In progress
protocol FTAppearanceManagerProtocol {
    @discardableResult
    func setUpAppearance(theme: FTThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance
}

open class FTAppearanceManager {

    static func getComponentName(_ appearanceName: String) -> (String, String?) {
        let components = appearanceName.components(separatedBy: ":")

        if components.count > 1 {
            return (components.first!, components.last)
        }

        return (appearanceName, nil)
    }

    static func setupThemes() {
        guard let app = FTThemesManager.getAppearance() as? FTThemeModel else { return }

        for theme in app where ((theme.value as? FTThemeModel) != nil) {

            if let themeObj: FTThemeModel = theme.value as? FTThemeModel {

                let components = getComponentName(theme.key)

                if let classTy: FTAppearanceManagerProtocol = FTReflection.swiftClassFromString(components.0) as? FTAppearanceManagerProtocol {

                    var appearanceContainer: [UIAppearanceContainer.Type]?
                    if
                        components.1 != nil,
                        let objecClass = FTReflection.swiftClassTypeFromString(components.1!) {
                        appearanceContainer = [objecClass] as? [UIAppearanceContainer.Type]
                    }

                    classTy.setUpAppearance(theme: themeObj, containerClass: appearanceContainer)
                }
            }
        }
    }
}

extension FTThemesManager {

    public static func setStatusBarBackgroundColor(_ color: UIColor?) {
        
        if
            let color = color,
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView,
            statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
}

extension UIView: FTAppearanceManagerProtocol {

    public func setUpAppearance(theme: FTThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {
        return type(of: self).setUpAppearance(theme: theme, containerClass: containerClass)
    }

    @discardableResult
    @objc public class func setUpAppearance(theme: FTThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {

        let appearance = (containerClass == nil) ?  self.appearance() : self.appearance(whenContainedInInstancesOf: containerClass!)

        if let tintColor = theme["tintColor"] {
            appearance.tintColor = FTThemesManager.getColor(tintColor as? String)
        }

        if let backgroundImage = theme["backgroundImage"] {
            self.setBackgroundImage(backgroundImage)
        }

        return appearance
    }
    
    @objc public class func setBackgroundImage(_ imageTheme: Any) {
        self.setBackgroundImage(imageType: FTThemeStyle.defaultStyle, imageName: imageTheme)
    }
    
    public class func setBackgroundImage(imageType: String?, imageName: Any) {
        
        if let types = imageName as? FTThemeModel {
            types.forEach { setBackgroundImage(imageType: $0, imageName: $1) }
        }
        
        guard let imageType = imageType else { return }
        
        if
            let image = FTThemesManager.getImage(imageName as? String),
            let segmentSelf = self as? UISegmentedControl.Type
        {
            segmentSelf.setBackgroundImage(imageType: imageType, image: image)
        }
    }
}

extension UISegmentedControl {

    override public class func setUpAppearance(theme: FTThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {
        return super.setUpAppearance(theme: theme, containerClass: containerClass)
//        let appearance = (containerClass == nil) ?  self.appearance() : self.appearance(whenContainedInInstancesOf: containerClass!)
//        return appearance
    }
    
    public class func setBackgroundImage(imageType: String, image: UIImage) {
        
        let image = image.withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        let appearance = UISegmentedControl.appearance()
        
        if imageType == "selected" {
            appearance.setBackgroundImage(image, for: .selected, barMetrics: .default)
        }
        else {
            appearance.setBackgroundImage(image, for: UIControl.State(), barMetrics: .default)
        }
    }
}

extension UINavigationBar {
    
    override public class func setUpAppearance(theme: FTThemeModel, containerClass: [UIAppearanceContainer.Type]?) -> UIAppearance {
        super.setUpAppearance(theme: theme, containerClass: containerClass)

        let appearance = (containerClass == nil) ?  self.appearance() : self.appearance(whenContainedInInstancesOf: containerClass!)

        if let value = theme["backIndicatorImage"] {
            appearance.backIndicatorImage = FTThemesManager.getImage(value)
        }
        if let value = theme["backIndicatorTransitionMaskImage"] {
            appearance.backIndicatorTransitionMaskImage = FTThemesManager.getImage(value)
        }
        if let value = theme["shadowImage"] {
            appearance.shadowImage = FTThemesManager.getImage(value)
        }
        if let value = theme["titleText"] as? FTThemeModel {
            appearance.titleTextAttributes = FTThemesManager.getTextAttributes(value)
        }
        if let value = theme["isTranslucent"] as? Bool {
            appearance.isTranslucent = value
            // FIXIT: Not able to update statusbar color if not set to `blackTranslucent`
            if value {
                appearance.barStyle = .blackTranslucent
            }
        }

        return appearance
    }
    
    override public class func setBackgroundImage(_ image: Any) {
        
        var defaultImage: UIImage? = FTThemesManager.getImage(image)
        var landScapeImage: UIImage?
        
        if let imageTheme = image as? FTThemeModel {
            defaultImage = FTThemesManager.getImage(imageTheme["default"])
            landScapeImage = FTThemesManager.getImage(imageTheme["landScape"])
        }
        
        if defaultImage != nil {
            self.applyBackgroundImage(navigationBar: nil, defaultImage: defaultImage!, landScapeImage: landScapeImage)
        }
    }
}

extension UITabBar {
    
    override public class func setBackgroundImage(_ image: Any) {
        
        let appearance = self.appearance()

        if let defaultImage = FTThemesManager.getImage(image) {
            appearance.backgroundImage = defaultImage
        }
    }
}
