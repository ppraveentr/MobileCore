[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
![Cocoapods](https://img.shields.io/cocoapods/l/MobileCore)
![Cocoapods](https://img.shields.io/cocoapods/v/MobileCore)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

[![Build Status](https://github.com/ppraveentr/MobileCore/actions/workflows/on-push.yml/badge.svg)](https://github.com/ppraveentr/MobileCore/actions/workflows/on-push.yml)
[![codecov](https://codecov.io/gh/ppraveentr/MobileCore/branch/master/graph/badge.svg?token=uHVmysGxFQ)](https://codecov.io/gh/ppraveentr/MobileCore)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ppraveentr_MobileCore&metric=alert_status)](https://sonarcloud.io/dashboard?id=ppraveentr_MobileCore)

Lets consider you are developing a Mobile application, be it for Prototyping or Enterprise, finding right set of utitlies all in one place or configuring application Theme, writing a Network-layer  isn't always easy and its time consuming to write the code from scratch. MobileCore takes care of all these hassles for you. 

Before we create our new iOS project, let's discuss the libraries and resources we will use.

## Get Started 

MobileCore a Swift library consisting in a set of extensions to help dealing with 
- [x] AppTheming - Configuring and maintaining Application's theme via simple JSON.
- [x] CoreComponents - Customised UIKit elements.
- [x] NetworkLayer - Creating and managing RESTfull service layer and Domain Object via JSON.
- [x] CoreUtility - Frequently used utility by extension. 

MobileCore contains an integrated sample workspace `MobileCoreExample` featuring the use-case on how this framework works.

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'MobileCore', '~> 0.1.3'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding MobileCore as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
.package(url: "https://github.com/ppraveentr/MobileCore.git", .upToNextMajor(from: "0.1.3"))
]
```

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
