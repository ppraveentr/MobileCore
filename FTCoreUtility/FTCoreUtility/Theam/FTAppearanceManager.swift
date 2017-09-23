//
//  FTAppearanceManager.swift
//  FTCoreUtility
//
//  Created by Praveen Prabhakar on 30/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
//TODO: In progress
protocol FTAppearanceManagerProtocol {
    func setUpAppearance(theme: FTThemeDic, inContainerClass cclassName: String?)
}

extension FTThemesManager {

    public class func setStatusBarBackgroundColor(_ color: UIColor) {
        
        if
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView,
            statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
}

extension UIView : FTAppearanceManagerProtocol {
    
    public func setUpAppearance(theme: FTThemeDic, inContainerClass cclassName: String?) {
        type(of: self).setUpAppearance(theme: theme, inContainerClass: cclassName)
    }
    
    @objc open class func setUpAppearance(theme: FTThemeDic, inContainerClass cclassName: String?) {
        
        let appearance = self.appearance()
        
        theme.forEach { (key, value) in
            
            switch key {
            case "tintColor":
                appearance.tintColor = FTThemesManager.getColor(value as? String)
                break
                
            case "backgroundImage":
                self.setBackgroundImage(value)
                break
                
            default:
                break
            }
        }
    }
    
    @objc open class func setBackgroundImage(_ imageTheme: Any) {
        self.setBackgroundImage(imageType: "default", imageName: imageTheme)
    }
    
    open class func setBackgroundImage(imageType: String?, imageName: Any) {
        
        if let types = imageName as? FTThemeDic {
            types.forEach({ setBackgroundImage(imageType: $0, imageName: $1) })
        }
        
        guard let imageType = imageType else { return }
        
        if let image = FTThemesManager.getImage(imageName as? String){
            
            if let segmentSelf = self as? UISegmentedControl.Type {
                segmentSelf.setBackgroundImage(imageType:imageType, image: image)
            }
        }
    }
}


open class FTAppearanceManager {
    
    class func getComponentName(_ appearanceName: String) -> (String, String?) {
        let components = appearanceName.components(separatedBy: ":")
        
        if components.count > 1 {
            return (components.first!, components.last)
        }
        
        return (appearanceName, nil)
    }
    
    class func __setupThemes__() {
        guard let app = FTThemesManager.getAppearance() as? FTThemeDic else { return }
        
        for theme in app where ((theme.value as? FTThemeDic) != nil) {
        
            if let themeObj: FTThemeDic = theme.value as? FTThemeDic {
                
                let components = getComponentName(theme.key)
                
                if let classTy: FTAppearanceManagerProtocol = FTReflection.swiftClassTypeFromString(components.0) as? FTAppearanceManagerProtocol {
                    classTy.setUpAppearance(theme: themeObj, inContainerClass: components.1)
                }
            }
        }
    }
}


extension UISegmentedControl {
    
    open override class func setUpAppearance(theme: FTThemeDic, inContainerClass cclassName: String?) {
        super.setUpAppearance(theme: theme, inContainerClass: cclassName)
        
    }
    
    open class func setBackgroundImage(imageType: String, image: UIImage) {
        
        let image = image.withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        let appearance = UISegmentedControl.appearance()
        
        switch imageType {
        case "selected":
            appearance.setBackgroundImage(image, for: .selected, barMetrics: .default)
            break;
        default:
            appearance.setBackgroundImage(image, for: UIControlState(), barMetrics: .default)
            break;
        }
    }
}

extension UINavigationBar {
    
    open override class func setUpAppearance(theme: FTThemeDic, inContainerClass cclassName: String?) {
        super.setUpAppearance(theme: theme, inContainerClass: cclassName)
        
        let appearance = self.appearance()
        
        theme.forEach { (key, value) in
            
            switch key {
            case "backIndicatorImage":
                appearance.backIndicatorImage = FTThemesManager.getImage(value)
                break
                
            case "backIndicatorTransitionMaskImage":
                appearance.backIndicatorTransitionMaskImage = FTThemesManager.getImage(value)
                break
                
            default:
                break
            }
        }
    }
    
    open override class func setBackgroundImage(_ image: Any) {
        
        var defaultImage: UIImage? = FTThemesManager.getImage(image)
        var landScapeImage: UIImage? = nil
        
        if let imageTheme = image as? FTThemeDic {
            defaultImage = FTThemesManager.getImage(imageTheme["default"])
            landScapeImage = FTThemesManager.getImage(imageTheme["landScape"])
        }
        
        if defaultImage != nil {
            self.applyBackgroundImage(navigationBar: nil, defaultImage: defaultImage!, landScapeImage: landScapeImage)
        }
    }
}

extension UITabBar {
    
    open override class func setBackgroundImage(_ image: Any) {
        
        let appearance = self.appearance()

        if let defaultImage = FTThemesManager.getImage(image) {
            appearance.backgroundImage = defaultImage
        }
    }
}

//TODO: In progress
enum Theme: Int {
    case `default`, dark, graphical
    
    var mainColor: UIColor {
        switch self {
        case .default:
            return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .graphical:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .default, .graphical:
            return .default
        case .dark:
            return .black
        }
    }
}

let SelectedThemeKey = "SelectedTheme"

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if
            let storedTheme = UserDefaults.standard.value(forKey: SelectedThemeKey) as? Int {
            return Theme(rawValue: storedTheme)!
        } else {
            return .default
        }
    }
    
    static func applyTheme(_ theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().barStyle = theme.barStyle
        
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
                
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: UIControlState())
        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: UIControlState())
        
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: UIControlState())
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: UIControlState())
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: UIControlState())
        
        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
        
    }
}