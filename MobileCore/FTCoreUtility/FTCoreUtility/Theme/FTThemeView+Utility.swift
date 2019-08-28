//
//  FTThemeView+Utility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTThemeModel = [String: Any]

public extension NSNotification.Name {
    static let kFTSwiftyAppearanceWillRefreshWindow = NSNotification.Name(rawValue: "FTSwiftyAppearanceWillRefreshWindow.Notofication")
    static let kFTSwiftyAppearanceDidRefreshWindow = NSNotification.Name(rawValue: "FTSwiftyAppearanceDidRefreshWindow.Notofication")
}

public struct FTThemeStyle {
    static let defaultStyle = "default"
    static let highlightedStyle = "highlighted"
    static let selectedStyle = "selected"
    static let disabledStyle = "disabled"
    
    static func allStyles() -> [String] {
        return [
            FTThemeStyle.highlightedStyle,
            FTThemeStyle.selectedStyle,
            FTThemeStyle.disabledStyle
        ]
    }
}

extension UIView {

    // Swizzling out view's layoutSubviews property for Updating Visual theme
    static var kSwizzleLayoutSubview = {
        FTInstanceSwizzling(UIView.self, #selector(layoutSubviews), #selector(swizzledLayoutSubviews))
    }

    static func setupThemes() {
        _ = kSwizzleLayoutSubview
    }
    
    // Theme style-name for the view
    @IBInspectable
    public var theme: String? {
        get {
            return UIView.aoThemes[self]
        }
        set {
            UIView.aoThemes[self] = newValue
            // Relaod view's theme, if styleName changes, when next time view layouts
            self.needsThemesUpdate = true
        }
    }

    public func updateVisualProperty() {
        self.needsThemesUpdate = true
    }

    // To tigger view-Theme styling
    private var needsThemesUpdate: Bool {
        get {
            return UIView.aoThemesNeedsUpdate[self] ?? false
        }
        set {
            UIView.aoThemesNeedsUpdate[self] = newValue
            if newValue {
                self.setNeedsLayout()
                // Update View with Theme properties
                self.generateVisualThemes()
            }
        }
    }
    
    // MARK: swizzled layoutSubviews
    @objc func swizzledLayoutSubviews() {
        if self.needsThemesUpdate {
            self.updateVisualThemes()
        }
        // Invoke view's original layoutSubviews
        self.swizzledLayoutSubviews()
    }
}

fileprivate extension UIView {

    // invalid SuperClass, to terminate loop
    static let kTerminalBaseClass = [UIView.self, NSObject.self, UIResponder.self]

    static let aoThemes = FTAssociatedObject<String>()
    static let aoThemesNeedsUpdate = FTAssociatedObject<Bool>()

    final func updateVisualThemes() {
        self.needsThemesUpdate = false
        // Update View with Theme properties
        self.generateVisualThemes()
    }
    
    func generateVisualThemes() {
        
        // If Theme is emtpy, retrun
        guard !FTThemesManager.themesJSON.isEmpty else {
            return
        }
        
        // Get ThemeName and view's name to get Theme's property
        guard let (className, themeName) = self.getThemeName() else {
            return
        }
        
        // Checkout if view supports Theming protocol
        let delegate: FTThemeProtocol? = self as? FTThemeProtocol
        
        // Get Theme property of view based on its state
        guard let themeDic = FTThemesManager.generateVisualThemes(forClass: className, styleName: themeName, subStyleName: delegate?.getThemeSubType()) else {
            return
        }
        
        // Step 1. Config view with new Theme-style
        self.configureTheme(themeDic)
        
        // Step 2. Only needed for UIControl types, Eg. Button
        guard let controlThemeSelf = self as? FTUIControlThemeProtocol else {
            return
        }

        // Get styles for diffrent states of UIControl
        if controlThemeSelf.getAllThemeSubType() {
            let baseName = themeName.components(separatedBy: ":").first
            var styles: FTThemeModel = [:]
            // For each style, get Theme value
            FTThemeStyle.allStyles().forEach { style in
                if let baseName = baseName,
                    let styleThemeDic = FTThemesManager.generateVisualThemes(forClass: className, styleName: baseName, subStyleName: style) {
                    // Create FTThemeModel as, ['ThemeStyle.UIControlState' : 'ActualTheme for the state']
                    styles[style] = styleThemeDic
                }
            }
            // Setup visual component for each style
            controlThemeSelf.setThemes(styles)
        }
    }
    
    // Retruns ('classname', 'Theme-style-name') only if both are valid
    func getThemeName() -> (String, String)? {
        
        // Vadidate className and ThemeName
        guard
            let className = getClassNameAsString(obj: self),
            let themeName = self.theme else {
            return nil
        }
        
        var baseClassName: String? = className
        let getSuperClass = { (obj: AnyObject) -> AnyClass? in
            guard let superClass: AnyClass = class_getSuperclass(type(of: obj)) else {
                return nil
            }

            if let className = getClassNameAsString(obj: superClass), className.hasPrefix("UI") {
                return nil
            }
            
            return superClass
        }

        // Iterate through superClass till we get a valid Theme class
        while baseClassName != nil && !FTThemesManager.isViewComponentValid(componentName: baseClassName!) {
            // Get super Class
            let superClass: AnyClass? = getSuperClass(type(of: self))
            
            // If SuperClass becomes invalid, terminate loop
            if let superClass = superClass, !UIView.kTerminalBaseClass.contains { $0 == superclass } {
                 baseClassName = getClassNameAsString(obj: superClass)
            }
            else {
                break
            }
        }
        
        if let baseClassName = baseClassName {
            // Create (class,theme) name pair
            return (baseClassName, themeName)
        }
        
        // If there is no valid Theme, return nil
        return nil
    }
    
    // Update view with styleValues
    @objc func configureTheme(_ themeDic: FTThemeModel?) {
        
        guard let theme = themeDic else {
            return
        }
        
        // Set theme for view
        self.swizzledUpdateTheme(theme)
        
        // Only needed for UIControl types, Eg. Button
        guard let controlThemeSelf = self as? FTUIControlThemeProtocol else {
            return
        }
        
        // Get all subTheme for all stats of the control
        let themeDic = [controlThemeSelf.getThemeSubType() ?? FTThemeStyle.defaultStyle: theme]
        controlThemeSelf.setThemes(themeDic)
    }
}

// MARK: UIView: FTThemeProtocol
extension UIView {
    
    @objc public func swizzledUpdateTheme(_ theme: FTThemeModel) {

        // "backgroundColor"
        if let textcolor = theme["backgroundColor"] {
            if
                let colorName = textcolor as? String,
                let color = FTThemesManager.getColor(colorName) {
                self.updateBackgroundColor(color)
                // TODO: For attributed title
            }
        }

        // "layer"
        // TODO: to generate a layer and add it as subView
        if let layerValue = theme["layer"] as? FTThemeModel {
            FTThemesManager.getBackgroundLayer(layerValue, toLayer: self.layer)
        }
        
        // Only needed for UIView types that has extended from FTThemeProtocol
        guard let controlThemeSelf = self as? FTThemeProtocol else {
            return
        }
        
        controlThemeSelf.updateTheme(theme)
    }
    
    // views background color
    public func updateBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}

// MARK: UIControl : Style for Different states for UIControl object
extension UIControl {
    
    public func getAllThemeSubType() -> Bool {
        return true
    }

    public func setThemes(_ themes: FTThemeModel) {
        
        guard let themeSelf = self as? FTUIControlThemeProtocol else {
            return
        }

        for (kind, value) in themes {
            
            guard let theme = value as? FTThemeModel else { continue }
            
            switch kind {
                
            case FTThemeStyle.defaultStyle:
                themeSelf.update(themeDic: theme, state: .normal)
                
            case FTThemeStyle.disabledStyle:
                themeSelf.update(themeDic: theme, state: .disabled)
                
            case FTThemeStyle.highlightedStyle:
                themeSelf.update(themeDic: theme, state: .highlighted)
                
            case FTThemeStyle.selectedStyle:
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
        NotificationCenter.default.post(name: .kFTSwiftyAppearanceWillRefreshWindow, object: self)
        UIView.animate(
            withDuration: animated ? 0.25 : 0,
            animations: { self.refreshAppearance() },
            completion: { _ in
            NotificationCenter.default.post(name: .kFTSwiftyAppearanceDidRefreshWindow, object: self)
            }
        )
    }
}
