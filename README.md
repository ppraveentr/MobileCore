[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/MobileCore.svg?branch=master)](https://travis-ci.org/ppraveentr/MobileCore)

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/29e1db8f665a4b0785c19002a45df0bb)](https://www.codacy.com/gh/ppraveentr/MobileCore/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ppraveentr/MobileCore&amp;utm_campaign=Badge_Grade)

Lets consider you are developing a Mobile application, be it for Prototyping or Enterprise, finding right set of utitlies all in one place or configuring application Theme, writing a Network-layer  isn't always easy and its time consuming to write the code from scratch. 

MobileCore takes care of all these hassles for you. Its a Swift library consisting in a set of extensions to help dealing with 
- [x] Programatically groping set of UIElements using auto-layout. 
- [x] Configuring and maintaining Application's theme via simple JSON. 
- [x] Creating and managing RESTfull service layer and Domain Object via JSON.
- [x] Customised UIKit elements.
- [x] Secure storage with Keychain.

MobileCore contains an integrated sample workspace `MobileCoreExample` featuring the use-case on how this framework works.

## Get Started 

Before we create our new iOS project, let's discuss the libraries and resources we will use.

```
MobileCore/
├── AppTheming
├── CoreUtility (Frequently used utility by extension)
├── CoreUI
└── NetworkLayer
```

### Using CococaPods

We'll be using CocoaPods to manage our dependencies. 
CocoaPods is a Ruby gem and command line tool  that makes it easy to add dependencies to your project. 
We prefer CocoaPods over Git submodules  due to its ease of implementation  and the wide variety of third-party libraries available as pods. 
CocoaPods will not only download the libraries we need and link them to our project in Xcode, it will also allow us to easily manage  and update which version of each library we want to use. Installing gem and creating a podfile is covered in more detail on their [CocoaPods](http://guides.cocoapods.org/using/getting-started.html) website. 

Below is the podfile we're going to use for this project.

    platform :ios, '9.0'
    target 'YourMobileApp' do
       pod 'MobileCore', '~> 0.1.0'
    end

Once you've updated your podfile, go ahead and run `$ pod install`.

#### Tips:
Add `@import MobileCore;` to your bridging header, to use it across the application.

That's it - now your are good to go and start writing beautiful application and let the MobileCore do the heavy lifting for you.

## TODO List

Below are the list of things I’m in plan adding into Mobile Core.

- Deeplinking and flow controler with content passing.
- Content Management for multi-language support using Core-data.
- Inbuild Crash reporter.
- Customizing Push notification.
- and more!!! as I think through 🤔

## Credits

Owned and maintained by Praveen P (@ppraveentr).

## Contributing

Bug reports and pull requests are most welcome.

## License

MobileCore is released under the MIT license. See LICENSE for details.

#### Note: The architecture is still under evolution.
