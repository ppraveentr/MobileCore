//
//  FTThemeManager.swift
//  MobileCore
//
//  Created by Praveen P on 20/08/19.
//  Copyright © 2019 Praveen P. All rights reserved.
//

import Foundation

// TODO: In progress
enum Theme: Int {
    case defaultStyle, dark, graphical
    
    var mainColor: UIColor {
        switch self {
        case .defaultStyle:
            return UIColor(red: 87.0 / 255.0, green: 188.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 242.0 / 255.0, green: 101.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        case .graphical:
            return UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .defaultStyle, .graphical:
            return .default
        case .dark:
            return .black
        }
    }
}

struct ThemeManager {
    
    static let kSelectedThemeKey = "SelectedTheme"
    
    static func currentTheme() -> Theme {
        if
            let storedTheme = UserDefaults.standard.value(forKey: kSelectedThemeKey) as? Int {
            return Theme(rawValue: storedTheme)!
        }
        else {
            return .defaultStyle
        }
    }
    
    static func applyTheme(_ theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: kSelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().barStyle = theme.barStyle
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: UIControl.State())
        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: UIControl.State())
        
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: UIControl.State())
        UISlider.appearance().setMaximumTrackImage(
            UIImage(named: "maximumTrack")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)),
            for: UIControl.State()
        )
        if let image = UIImage(named: "minimumTrack")?.withRenderingMode(.alwaysTemplate) {
            let reSizedImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0))
            UISlider.appearance().setMinimumTrackImage(reSizedImage, for: UIControl.State())
        }
        
        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
    }
}
