# MobileCore

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/MobileCore.svg?branch=master)](https://travis-ci.org/ppraveentr/MobileCore)

Lets consider you are developing a Mobile application, be it for Prototyping or Enterprise, writing Auto-Layout or Network-layer code from scratch isn't always easy and its time consuming. This Core component takes care of all these hassles for you.

MobileCore is a Swift library consisting in a set of extensions to help dealing with 
- [x] Auto Layout programatically. 
- [x] Defining and managing RESTfull service layer in JSON format.
- [x] Utility for Domain Object creation from JSON to Swift classes.


### What's included

Within the download you'll find the following sub-projects and an integrated sample workspace `FTMobileCoreSampleWorkspace`.

```
MobileCore/
├── FTCoreUtility
├── FTMobileCore
├── FTMobileCoreUI
└── FTMobileCoreSampleWorkspace
```

## FTCoreUtility

Contains most frequently used utilities as extension files. 
More information about this project can be at [`FTCoreUtility`]().

### Application Theming

* `@IBInspectable public var theme: String?` — inspectable property to set appearance style from Interface Builder for all UIView elements

All you need to do is load the `Themes.json` in AppleDelegate file and you are set for start developing the application also pass on `Bundle` for the images used.

#### Theme Configuration
```swift
 if
    let theme = Bundle.main.path(forResource: "Themes", ofType: "json"),
    let themeContent: FTThemeDic = try! theme.jsonContentAtPath() {
        FTThemesManager.setupThemes(themes: themeContent, imageSourceBundle: [Bundle(for: AppDelegate.self)])
 }
```
The appearance of each unique property can be added as entity in `Themes.json` and set the respective property name for UIElements. 

#### Example
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

#### Themes.json
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


## Manually setup from GitHub

- Download the source ['MobileCore'](https://github.com/ppraveentr/MobileCore.git) to your subdirectory.
- Add below Projects to yours workspace.
```
MobileCore/
├── FTCoreUtility
├── FTMobileCore
└── FTMobileCoreUI
```
- Folow the steps provided in ['Embedding Frameworks In An App'](https://developer.apple.com/library/content/technotes/tn2435/_index.html) to link the 'MobileCore' frameworks to your Xcode project.
- Add the following imports to your bridging header.
	- #import <FTMobileCore/FTMobileCore.h>
	- #import <FTMobileCoreUI/FTMobileCoreUI.h>

That's it - now your are good to go and start writing beautiful applicaiton! Let the MobileCode most of the heavy lifting for you.


## Prototype
[`NovelReader`](https://github.com/ppraveentr/Concepts/tree/master/NovelReader) is a prototype describing working of MobileCore.

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/Concepts.svg?branch=master)](https://travis-ci.org/ppraveentr/Concepts)


## Credits

Owned and maintained by Praveen P (@ppraveentr).

## Contributing

Bug reports and pull requests are welcome.

## License

MobileCore is released under the MIT license. See LICENSE for details.

#### Note
MobileCore architecture is still under evolution.
