## FTCoreUtility

Contains most frequently used utilities as extension files. 
More information about this project can be at [`FTCoreUtility`]().

### Application Theming

* `@IBInspectable public var theme: String?` — inspectable property to set appearance style from Interface Builder for all UIView elements

All you need to do is load the `Themes.json` in AppleDelegate file and you are set for start developing the application. also pass on `Bundle` for the images used.

#### Theme loading
```swift
 if
    let theme = Bundle.main.path(forResource: "Themes", ofType: "json"),
    let themeContent: FTThemeDic = try! theme.jsonContentAtPath() {
        FTThemesManager.setupThemes(themes: themeContent, imageSourceBundle: [Bundle(for: AppDelegate.self)])
	}
```
The appearance of each unique property can be added as entity in `Themes.json` and set the respective property name for UIElements. 

#### Theme Example
![Button theme](https://github.com/ppraveentr/Gif-images/blob/master/MobileCore-Button-Tap.gif)
```swift

 let button = FTButton()
 button.theme = "button14R"
 button.setTitle("Tap me", for: .normal)
        
        
 let buttonDisabled = FTButton()
 buttonDisabled.theme = "button14R"
 buttonDisabled.setTitle("Disabled", for: .normal)
 buttonDisabled.isEnabled = false
```

#### Sample Themes.json
```json
{
    "type": "Themes",
    "color": {
        "default": "#FFFFFF",
        "clear": "clear",
        "black": "#000000",
        "red": "#b70b39",
        "white": "#FFFFFF"
    },
    "font": {
        "default": {
            "name": "system",
            "size": "13.0"
        },
        "system14": {
            "_super": "default",
            "size": "14.0"
        }
    },
    "appearance": {
        "UINavigationBar:UINavigationController": {
            "barTintColor": "white",
            "tintColor": "white",
            "isTranslucent": false,
            "backgroundImage": {
                "default": "@Pixel"
            },
            "shadowImage": "@empty"
        },
        "UINavigationBar": {
            "barTintColor": "black",
            "isTranslucent": true
        },
        "UISegmentedControl": {
            "tintColor": "black",
            "backgroundImage": {
                "default": "@upArrow",
                "selected": "@Pixel"
            },
        }
    },
    "components": {
        "FTView": {
            "default": {
                "backgroundColor": "white"
            }
        },
        "FTButton": {
            "default": {
                "textfont": "system14",
                "textcolor": "black",
                "backgroundColor": "clear",
                "layer": {
                    "cornerRadius": 5,
                    "borderWidth": 2,
                    "borderColor": "red"
                }
            },
            "button14R": {
                "_super": "default",
                "textcolor": "red"
            },
            "button14R:highlighted": {
                "_super": "default",
                "textcolor": "green"
            },
            "button14R:disabled": {
                "_super": "default",
                "textcolor": "yellow"
            }
        },
        "FTLabel": {
            "default": {
                "textfont": "system14",
                "textcolor": "black",
                "backgroundColor": "clear",
                "isLinkUnderlineEnabled": true,
                "isLinkDetectionEnabled": true
            },
            "system14R": {
                "_super": "default",
                "textcolor": "red"
            }
        }
    }
}
```