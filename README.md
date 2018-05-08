# MobileCore

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/MobileCore.svg?branch=master)](https://travis-ci.org/ppraveentr/MobileCore)

Lets consider you are developing a Mobile application, be it for Prototyping or Enterprise, finding right set of utitlies all in one place or configuring application Theme, writing a Network-layer  isn't always easy and its time consuming to write the code from scratch. 

MobileCore takes care of all these hassles for you. Its a Swift library consisting in a set of extensions to help dealing with 
- [x] Programatically groping set of UIElements using auto-layout. 
- [x] Configuring and maintaining Application's theme via simple JSON. 
- [x] Creating and managing RESTfull service layer and Domain Object via JSON.
- [x] Customized UIKit elements.


### What's included

MobileCore contains the following projects, an integrated sample workspace `FTMobileCoreSampleWorkspace` featuring the usecase on how these framework works together.

```
MobileCore/
├── FTCoreUtility
├── FTMobileCore
├── FTMobileCoreUI
└── FTMobileCoreSampleWorkspace
```

## FTCoreUtility

FTCoreUtility is a shared component used accross MobileCore. This contains most frequently used extension utilites. 

More information about this project can be at [`FTCoreUtility`]().

### Application Theming

FTCoreUtility provides iOS developers the ability to create a coherent color theme throughout their entire application, removing the need to mess with the dozens of UIAppearance proxies for each UI component in a single line of code.

It provides hierarchical management of themes based on user defined components, so that it is easy to over-ride your default theme for particular contexts.

Themes are customized via JSON configuration file which make them easy for editing. Additionally, this repository can build a theme browser universal application that designers may use to see the themes already configured.

All you need to do is load the respective `Themes.json` file once and you are all set for start developing the application. 

Incase if you need to use images for background, all you need to also load respetive image's source `Bundle` into FTThemesManager.

```swift
 if
    let theme = Bundle.main.path(forResource: "Themes", ofType: "json"),
    let themeContent: FTThemeDic = try! theme.jsonContentAtPath() {
        FTThemesManager.setupThemes(themes: themeContent, imageSourceBundle: [Bundle(for: AppDelegate.self)])
 }
 
 //Searches for respective bundle's name in main
 FTThemesManager.addImageSourceBundle(imageSource: "AppDelegate".bundle())
 
 //Loads the bundle respetive to the class's Module
 FTThemesManager.addImageSourceBundle(imageSource: Bundle(for: AppDelegate.self))
 
```

#### Theme Configuration

The appearance of each unique property can be added as entity in `Themes.json` and set the respective property name for UIElements. 

* `@IBInspectable public var theme: String?` — inspectable property to set appearance style from Interface Builder for all UIView elements

#### Usage
![UIElements: Button theme](https://github.com/ppraveentr/Gif-images/blob/master/MobileCore-Button-Tap.gif)
```swift
//Enabled Button
 let button = FTButton()
 button.theme = "button14R"
 button.setTitle("Tap me", for: .normal)
        
//Disabled Button
 let buttonDisabled = FTButton()
 buttonDisabled.theme = "button14R"
 buttonDisabled.setTitle("Disabled", for: .normal)
 buttonDisabled.isEnabled = false
```

#### Themes.json sample
Here is the sample Theme.json used in 'FTMobileCoreSampleWorkspace'.

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

## Get Started

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

## TODO List

Below are the list of things I’m in plan adding into Mobile Core.

- Deeplinking and flow controler with content passing.
- Content Management for multi-language support using Core-data.
- Secure storage with Keychain.
- Inbuild Crash reporter.
- Customizing Push notification.
- Simplyfing FTCoreUtility’s FTUI<elements> to swift extension.
- and more!!! as I think through 🤔

## Prototype
[`NovelReader`](https://github.com/ppraveentr/Concepts/tree/master/NovelReader) is a prototype describing working of MobileCore.

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/Concepts.svg?branch=master)](https://travis-ci.org/ppraveentr/Concepts)


## Credits

Owned and maintained by Praveen P (@ppraveentr).

## Contributing

Bug reports and pull requests are most welcome.

## License

MobileCore is released under the MIT license. See LICENSE for details.

#### Note: The architecture is still under evolution.
