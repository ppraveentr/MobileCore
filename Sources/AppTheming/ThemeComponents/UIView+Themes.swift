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

public typealias ThemeModel = [String: Any]

extension ThemeModel {
    subscript(key: ThemeKey) -> Any? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    
    subscript(theme: ThemesType) -> Any? {
        get { self[theme.rawValue] }
        set { self[theme.rawValue] = newValue }
    }
}

public enum ThemesType: String, CaseIterable {
    case color, font, layer, appearance, link, components
}

public enum ThemeKey: String, CaseIterable {
    // Theme Super Components
    case defaultValue = "default", superComponent = "_super"
    // Image
    case clear, image, backgroundImage, backIndicatorImage, backIndicatorTransitionMaskImage, shadowImage
    // Appearanc
    case titleText, isTranslucent
    case tintColor, barTintColor, backgroundColor, foregroundColor
    // Font
    case system, boldSystem, italicSystem
    // Label
    case font, name, size, weight, textfont, textcolor, underline, style
    case isLinkUnderlineEnabled, isLinkDetectionEnabled
    // Layer
    case masksToBounds, cornerRadius, borderWidth, borderColor
    case shadowPath, shadowOffset, shadowColor, shadowRadius, shadowOpacity
}

public extension NSNotification.Name {
    static let kAppearanceWillRefreshWindow = NSNotification.Name(rawValue: "kAppearance.willRefreshWindow.Notofication")
    static let kAppearanceDidRefreshWindow = NSNotification.Name(rawValue: "kAppearance.didRefreshWindow.Notofication")
}

public struct ThemeStyle {
    public static let defaultStyle = "default"
    public static let highlightedStyle = "highlighted"
    public static let selectedStyle = "selected"
    public static let disabledStyle = "disabled"
    
    public static func allStyles() -> [String] {
        [
            ThemeStyle.highlightedStyle,
            ThemeStyle.selectedStyle,
            ThemeStyle.disabledStyle
        ]
    }
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
        if let themeDic = ThemesManager.generateVisualThemes(forClass: className, styleName: themeName, subStyleName: delegate?.subStyleName()) {
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
                    let styleThemeDic = ThemesManager.generateVisualThemes(forClass: className, styleName: baseName, subStyleName: style) {
                    // Create ThemeModel as, ['ThemeStyle.UIControlState' : 'ActualTheme for the state']
                    styles[style] = styleThemeDic
                }
            }
            // Setup visual component for each style
            self.setThemes(styles)
        }
    }
    
    // Retruns ('classname', 'Theme-style-name') only if both are valid
    func getThemeName() -> (String, String)? {
        // Vadidate className and ThemeName
        guard
            let className = Reflection.classNameAsString(self),
            let themeName = self.theme else {
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
        let themeDic = [self.subStyleName() ?? ThemeStyle.defaultStyle: theme]
        self.setThemes(themeDic)
    }
}

// MARK: UIView: ThemeProtocol
extension UIView {
    func setupViewTheme(_ theme: ThemeModel) {
        // "backgroundColor"
        if let colorName = theme[ThemeKey.backgroundColor],
           let color = ThemesManager.getColor(colorName as? String) {
            self.updateBackgroundColor(color)
        }
        // "layer": To generate a layer and add it as subView
        if let layerName = theme[ThemesType.layer] as? String,
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
            guard let theme = value as? ThemeModel else { continue }
            switch kind {
            case ThemeStyle.defaultStyle:
                themeSelf.update(themeDic: theme, state: .normal)
            case ThemeStyle.disabledStyle:
                themeSelf.update(themeDic: theme, state: .disabled)
            case ThemeStyle.highlightedStyle:
                themeSelf.update(themeDic: theme, state: .highlighted)
            case ThemeStyle.selectedStyle:
                themeSelf.update(themeDic: theme, state: .selected)
            default:
                break
            }
        }
    }
}

// MARK: Window Refresh
public extension UIWindow {
    @nonobjc private func refreshAppearance() {
        let constraints = self.constraints
        removeConstraints(constraints)
        for subview in subviews {
            subview.removeFromSuperview()
            addSubview(subview)
        }
        addConstraints(constraints)
    }

    /// Refreshes appearance for the window
    /// - Parameter animated: if the refresh should be animated
    func refreshAppearance(animated: Bool) {
        NotificationCenter.default.post(name: .kAppearanceWillRefreshWindow, object: self)
        UIView.animate(
            withDuration: animated ? 0.25 : 0,
            animations: { self.refreshAppearance() },
            completion: { _ in
            NotificationCenter.default.post(name: .kAppearanceDidRefreshWindow, object: self)
            }
        )
    }
}
