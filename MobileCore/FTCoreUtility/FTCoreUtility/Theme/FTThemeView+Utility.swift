//
//  FTThemeView+Utility.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 05/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

public typealias FTThemeModel = [String : Any]

public extension NSNotification.Name {
    static let FTSwiftyAppearanceWillRefreshWindow = NSNotification.Name(rawValue: "FTSwiftyAppearanceWillRefreshWindow.Notofication")
    static let FTSwiftyAppearanceDidRefreshWindow = NSNotification.Name(rawValue: "FTSwiftyAppearanceDidRefreshWindow.Notofication")
}

public struct FTThemeStyle {
    public static let defaultStyle = "default"
    static let highlightedStyle = "highlighted"
    static let selectedStyle = "selected"
    static let disabledStyle = "disabled"
    
    static func allStyles() -> [String] {
        return [FTThemeStyle.highlightedStyle,
                FTThemeStyle.selectedStyle,
                FTThemeStyle.disabledStyle]
    }
    
}

extension UIView {

    // Swizzling out view's layoutSubviews property for Updating Visual theme
    static var SwizzleLayoutSubview = {
        FTInstanceSwizzling(UIView.self, #selector(layoutSubviews), #selector(swizzled_layoutSubviews))
    }

    static func __setupThemes__() {
        _ = SwizzleLayoutSubview
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
    
    override open func prepareForInterfaceBuilder() {
//        showErrorIfInvalidStyles()
    }
    
    // MARK: swizzled layoutSubviews
    @objc func swizzled_layoutSubviews() {
        if self.needsThemesUpdate {
            self.__updateVisualThemes__()
        }
        // Invoke view's original layoutSubviews
        self.swizzled_layoutSubviews()
    }
    
}

fileprivate extension UIView {

    // invalid SuperClass, to terminate loop
    static let kTerminalBaseClass = [UIView.self, NSObject.self, UIResponder.self]

    static let aoThemes = FTAssociatedObject<String>()
    static let aoThemesNeedsUpdate = FTAssociatedObject<Bool>()

    final func __updateVisualThemes__() {
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
        guard let (className, themeName) = self.get_ThemeName() else {
            return
        }
        
        // Checkout if view supports Theming protocol
        let delegate: FTThemeProtocol? = self as? FTThemeProtocol
        
        // Get Theme property of view based on its state
        guard let themeDic = FTThemesManager.generateVisualThemes(forClass: className,
                                                                  withStyleName: themeName,
                                                                  withSubStyleName: delegate?.get_ThemeSubType()) else {
            return
        }
        
        // Step 1. Config view with new Theme-style
        self.configureTheme(themeDic)
        
        // Step 2. Only needed for UIControl types, Eg. Button
        guard let controlThemeSelf = self as? FTUIControlThemeProtocol else {
            return
        }

        // Get styles for diffrent states of UIControl
        if controlThemeSelf.get_AllThemeSubType() == true {
            
            let baseName = themeName.components(separatedBy: ":").first

            var styles: FTThemeModel = [:]

            // For each style, get Theme value
            FTThemeStyle.allStyles().forEach { (style) in
                
                if let styleThemeDic = FTThemesManager.generateVisualThemes(forClass: className,
                                                                       withStyleName: baseName!,
                                                                       withSubStyleName: style) {
                    
                    // Create FTThemeModel as, ['ThemeStyle.UIControlState' : 'ActualTheme for the state']
                    styles[style] = styleThemeDic
                }
            }
            
            // Setup visual component for each style
            controlThemeSelf.setThemes(styles)
        }
    }
    
    // Retruns ('classname', 'Theme-style-name') only if both are valid
    func get_ThemeName() -> (String, String)? {
        
        // Vadidate className and ThemeName
        guard
            let className = get_classNameAsString(obj: self),
            let themeName = self.theme else {
            return nil
        }
        
        var baseClassName: String? = className

        let getSuperClass = { (obj: AnyObject) -> AnyClass? in
            guard let superClass: AnyClass = class_getSuperclass(type(of: obj)) else {
                return nil
            }

            if let className = get_classNameAsString(obj: superClass), className.hasPrefix("UI") {
                return nil
            }
            
            return superClass
        }

        // Iterate through superClass till we get a valid Theme class
        while baseClassName != nil && !FTThemesManager.isViewComponentValid(componentName: baseClassName!) {
            // Get super Class
            let superClass: AnyClass? = getSuperClass(type(of: self))
            
            // If SuperClass becomes invalid, terminate loop
            if let superClass = superClass, !UIView.kTerminalBaseClass.contains(where: { (obj) -> Bool in
                return obj == superclass
            }) {
                 baseClassName = get_classNameAsString(obj: superClass)
            } else {
                break
            }
        }
        
        // If there is no valid Theme, return nil
        if baseClassName == nil {
            return nil
        }
        
        // Create (class,theme) name pair
        return (baseClassName!, themeName)
    }
    
    // Update view with styleValues
    @objc func configureTheme(_ themeDic: FTThemeModel?) {
        
        guard let theme = themeDic else {
            return
        }
        
        // Set theme for view
        self.swizzled_updateTheme(theme)
        
        // Only needed for UIControl types, Eg. Button
        guard let controlThemeSelf = self as? FTUIControlThemeProtocol else {
            return
        }
        
        // Get all subTheme for all stats of the control
        let themeDic = [controlThemeSelf.get_ThemeSubType() ?? FTThemeStyle.defaultStyle : theme]
        controlThemeSelf.setThemes(themeDic)
    }

}

// MARK: UIView: FTThemeProtocol
extension UIView {
    
    @objc public func swizzled_updateTheme(_ theme: FTThemeModel) {

        // "backgroundColor"
        if let textcolor = theme["backgroundColor"] {
            if
                let colorName = textcolor as? String,
                let color = FTThemesManager.getColor(colorName) {
                self.theme_backgroundColor(color)
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
    public func theme_backgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }

}

// MARK: UIControl : Style for Different states for UIControl object
extension UIControl {
    
    public func get_AllThemeSubType() -> Bool {
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
                break
                
            case FTThemeStyle.disabledStyle:
                themeSelf.update(themeDic: theme, state: .disabled)
                break
                
            case FTThemeStyle.highlightedStyle:
                themeSelf.update(themeDic: theme, state: .highlighted)
                break
                
            case FTThemeStyle.selectedStyle:
                themeSelf.update(themeDic: theme, state: .selected)
                break
                
            default:
                break
            }
        }
    }
    
}

// MARK: Window Refresh
public extension UIWindow {

    @nonobjc private func _refreshAppearance() {
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
        NotificationCenter.default.post(name: .FTSwiftyAppearanceWillRefreshWindow, object: self)
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            self._refreshAppearance()
        }, completion: { _ in
            NotificationCenter.default.post(name: .FTSwiftyAppearanceDidRefreshWindow, object: self)
        })
    }
    
}
