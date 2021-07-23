//
//  UIView+Themes.swift
//  MobileCore-AppTheming
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

#if canImport(CoreUtility)
import CoreUtility
#endif
import Foundation
import UIKit

// MARK: AssociatedKey
private extension AssociatedKey {
    static var gradientLayer = "gradientLayer"
}

extension UIView {
    // Theme style-name for the view
    @IBInspectable
    public var theme: String? {
        get { UIView.aoThemes[self] }
        set {
            UIView.aoThemes[self] = newValue
            // Relaod view's theme, if styleName changes, when next time view layouts
            self.needsThemesUpdate = true
        }
    }

    public func updateVisualProperty() {
        self.needsThemesUpdate = true
    }
    
    public func updateShadowPathIfNeeded() {
        if self.layer.shadowPath != nil {
            let rect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
        if let gardian: CAGradientLayer = AssociatedObject.getAssociated(self, key: &AssociatedKey.gradientLayer) {
            gardian.frame = self.bounds
        }
    }

    // To tigger view-Theme styling
    private var needsThemesUpdate: Bool {
        get { UIView.aoThemesNeedsUpdate[self] ?? false }
        set {
            UIView.aoThemesNeedsUpdate[self] = newValue
            if newValue {
                self.setNeedsLayout()
                // Update View with Theme properties
                self.generateVisualThemes()
            }
        }
    }
}

fileprivate extension UIView {
    // invalid SuperClass, to terminate loop
    static let kTerminalBaseClass = [UIView.self, NSObject.self, UIResponder.self]
    static let aoThemes = AssociatedObject<String>()
    static let aoThemesNeedsUpdate = AssociatedObject<Bool>()

    final func updateVisualThemes() {
        self.needsThemesUpdate = false
        // Update View with Theme properties
        self.generateVisualThemes()
    }
    
    func generateVisualThemes() {
        // If Theme is emtpy, retrun
        guard !ThemesManager.themesJSON.isEmpty else { return }
        // Get ThemeName and view's name to get Theme's property
        guard let (className, themeName) = self.getThemeName() else { return }
        // Checkout if view supports Theming protocol
        let delegate: ThemeProtocol? = self as? ThemeProtocol
        // Get Theme property of view based on its state
        if let themeDic = ThemesManager.generateVisualThemes(className, styleName: themeName, subStyleName: delegate?.subStyleName()) {
            // Step 1. Config view with new Theme-style
             self.configureTheme(themeDic)
        }
        
        // Step 2. Only needed for UIControl types, Eg. Button
        guard let self = self as? ControlThemeProtocol else { return }
        // Get styles for diffrent states of UIControl
        if self.getAllThemeSubType() {
            let baseName = themeName.components(separatedBy: ":").first
            var styles: ThemeModel = [:]
            // For each style, get Theme value
            ThemeStyle.allStyles().forEach { style in
                if let baseName = baseName,
                    let styleThemeDic = ThemesManager.generateVisualThemes(className, styleName: baseName, subStyleName: style) {
                    // Create ThemeModel as, ['ThemeStyle.UIControlState' : 'ActualTheme for the state']
                    styles[style.rawValue] = styleThemeDic
                }
            }
            // Setup visual component for each style
            self.setThemes(styles)
        }
    }
    
    // Retruns ('classname', 'Theme-style-name') only if both are valid
    func getThemeName() -> (String, String)? {
        // Vadidate className and ThemeName
        guard let className = Reflection.classNameAsString(self), let themeName = self.theme else {
            return nil
        }
        
        var baseClassName: String? = className
        let getSuperClass = { (obj: AnyObject) -> AnyClass? in
            guard let superClass: AnyClass = class_getSuperclass(type(of: obj)) else { return nil }
            if let className = Reflection.classNameAsString(superClass), className.hasPrefix("UI") {
                return nil
            }
            return superClass
        }

        // Iterate through superClass till we get a valid Theme class
        while baseClassName != nil && !ThemesManager.isViewComponentValid(componentName: baseClassName!) {
            // Get super Class
            let superClass: AnyClass? = getSuperClass(type(of: self))
            // If SuperClass becomes invalid, terminate loop
            if let superClass = superClass, !UIView.kTerminalBaseClass.contains(where: { $0 == superclass }) {
                baseClassName = Reflection.classNameAsString(superClass)
            }
            else {
                break
            }
        }
        // Create (class,theme) name pair
        if let baseClassName = baseClassName {
            return (baseClassName, themeName)
        }
        // If there is no valid Theme, return nil
        return nil
    }
    
    // Update view with styleValues
    @objc func configureTheme(_ themeDic: ThemeModel?) {
        guard let theme = themeDic else { return }
        // Set theme for view
        self.setupViewTheme(theme)
        // Only needed for UIControl types, Eg. Button
        guard let self = self as? ControlThemeProtocol else { return }
        // Get all subTheme for all stats of the control
        let themeStyleName = self.subStyleName() ?? ThemeStyle.defaultStyle
        let themeDic = [themeStyleName.rawValue: theme]
        self.setThemes(themeDic)
    }
}

// MARK: UIView: ThemeProtocol
extension UIView {
    /// Updates View's based on theme
    /// 1) backgroundColor,
    /// 2) Adds CAGradientLayer,
    /// 3) Setup CALayer for shadowLayer
    /// 4) Custom config the component based on ThemeProtocol
    func setupViewTheme(_ theme: ThemeModel) {
        // "backgroundColor"
        if let colorName = theme[ThemeType.Key.backgroundColor],
           let color = ThemesManager.getColor(colorName as? String) {
            self.updateBackgroundColor(color)
        }
        /// 2) Adds CAGradientLayer,
        if let model = theme[ThemeType.Key.gradientLayer] as? ThemeModel,
           let layer = ThemesManager.getGradientLayer(model) {
            // Remove any old layer
            let oldGradian = AssociatedObject<CAGradientLayer>.getAssociated(self, key: &AssociatedKey.gradientLayer)
            oldGradian?.removeFromSuperlayer()
            // Set new layer
            AssociatedObject<CAGradientLayer>.setAssociated(self, value: layer, key: &AssociatedKey.gradientLayer)
            self.layer.insertSublayer(layer, at: 0)
        }
        /// Setup CALayer: Generate a layer and add it as subView
        if let layerName = theme[ThemeType.layer] as? String,
           let layerValue = ThemesManager.getLayer(layerName) {
            ThemesManager.getBackgroundLayer(layerValue, toLayer: self.layer)
        }
        // Only needed for UIView types that has extended from ThemeProtocol
        guard let self = self as? ThemeProtocol else { return }
        self.updateTheme(theme)
    }
    
    // views background color
    public func updateBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}

// MARK: UIControl : Style for Different states for UIControl object
extension UIControl {
    public func getAllThemeSubType() -> Bool { true }

    public func setThemes(_ themes: ThemeModel) {
        guard let themeSelf = self as? ControlThemeProtocol else { return }
        for (kind, value) in themes {
            guard let theme = value as? ThemeModel, let style = ThemeStyle(rawValue: kind) else { continue }
            switch style {
            case ThemeStyle.defaultStyle:
                themeSelf.update(themeDic: theme, state: .normal)
            case ThemeStyle.disabledStyle:
                themeSelf.update(themeDic: theme, state: .disabled)
            case ThemeStyle.highlightedStyle:
                themeSelf.update(themeDic: theme, state: .highlighted)
            case ThemeStyle.selectedStyle:
                themeSelf.update(themeDic: theme, state: .selected)
            }
        }
    }
}
